/* Copyright (c) 2013-2015 PLUMgrid, http://plumgrid.com
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of version 2 of the GNU General Public
 * License as published by the Free Software Foundation.
 */

#ifdef asm_inline
#undef asm_inline
#define asm_inline asm
#endif

#include <linux/skbuff.h>
#include <linux/netdevice.h>
#include <linux/version.h>
#include <uapi/linux/bpf.h>
#include "bpf_helpers.h" // for v5.3
#include "hotbpf_common.h"

struct bpf_map_def SEC("maps") allocs_map = {
    .type = BPF_MAP_TYPE_HASH,
    .key_size = sizeof(u32),
    .value_size = sizeof(u32),
    .max_entries = 4096,
};

struct bpf_map_def SEC("maps") inuse_map = {
    .type = BPF_MAP_TYPE_HASH,
    .key_size = sizeof(u64),
    .value_size = sizeof(u64),
    .max_entries = 4096,
};

SEC("kprobe/nf_tables_newtable")
int probe_nf_tables_newflowtable()
{
    u32 pid = bpf_get_current_pid_tgid();
    u32 val = 1;
    int err = 0;
    err = bpf_map_update_elem(&allocs_map, &pid, &val, BPF_ANY);
    if (err < 0) {
        bpf_printk("single_open start: update map failed %d\n", err);
        return err;
    }
    return 0;
}

int clear_allocs_map()
{
    u32 pid = bpf_get_current_pid_tgid();
    int err = 0;
    u32* pval = NULL;
    u32 val = 0;
    pval = bpf_map_lookup_elem(&allocs_map, &pid);
    if (pval) {
        err = bpf_map_delete_elem(&allocs_map, &pid);
        if (err < 0) {
            bpf_printk("single_open end: delete map failed %d  %u  %u\n", err, pid, *pval);
            return err;
        }
    } else {
        bpf_printk("single_open end bad thing happens pid:%d  *pval:%u\n", pid, *pval);
    }
    return 0;
}

int in_context(u32 pid)
{
    u32 *pval = NULL;
    pval = bpf_map_lookup_elem(&allocs_map, &pid);
    if (pval)
        return 1;
    else
        return -1;
    return 0;
}

SEC("kprobe/kmem_cache_alloc_trace")
int probe_kmem_cache_alloc_trace(struct pt_regs *ctx)
{
    unsigned long alloc_addr = 0;
    unsigned long alloc_size = 0;

    u32 pid = bpf_get_current_pid_tgid();
    int err = in_context(pid);
    if (err < 0) {
        return -1;
    } else {   
	    clear_allocs_map();

        alloc_size = PT_REGS_PARM3(ctx);
        alloc_addr = bpf_vmalloc(alloc_size);

        if (!alloc_addr) {
            bpf_printk("[hotbpf] fail to do vmalloc, back to original\n");
        } else {
            // skip original alloc and override return value
            bpf_printk("[hotbpf] do vmalloc and return 0x%lx\n", alloc_addr);
            bpf_map_update_elem(&inuse_map, &alloc_addr, &alloc_size, BPF_ANY);
            bpf_override_return2(ctx, (unsigned long)alloc_addr);
        }
    }

    // overhead statistics
    // value = bpf_map_lookup_elem(&bpf_duration_map, &loc);
    // if (value)
    //  *value = delta;
    // else
    //  bpf_map_update_elem(&bpf_duration_map, &loc, &delta, BPF_ANY);

    return 0;
}

SEC("kprobe/kfree")
int probe_kfree(struct pt_regs* ctx) 
{
	unsigned long alloc_addr = PT_REGS_PARM1(ctx);
	long *alloc_size = bpf_map_lookup_elem(&inuse_map, &alloc_addr);
	// vulnerable object, do OTA
	if (alloc_size) { 
		bpf_printk("[hotbpf] never do vfree for 0x%lx\n", alloc_addr);
		// bpf_vfree((void *)alloc_addr);

		// delete from inuse map
		bpf_map_delete_elem(&inuse_map, &alloc_addr);

		// add to infree map
		/*
		long *infree_size = bpf_map_lookup_elem(&infree_map, &alloc_addr);
		if (infree_size)
			*infree_size = 0; // never execute this line
		else
			 bpf_map_update_elem(&infree_map, &alloc_addr, alloc_size, BPF_ANY);
		*/

		// skip orginal kfree
		bpf_override_return2(ctx, (unsigned long)0);
		return 0;
	} else {
		return 0;
	}
}

char _license[] SEC("license") = "GPL";
u32 _version SEC("version") = LINUX_VERSION_CODE;
