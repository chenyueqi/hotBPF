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
#include "bpf_tracing.h"

struct bpf_map_def SEC("maps") bpf_duration_map = {
	.type = BPF_MAP_TYPE_HASH,
	.key_size = sizeof(u64),
	.value_size = sizeof(u64),
	.max_entries = 4096,
};

struct bpf_map_def SEC("maps") inuse_map = {
	.type = BPF_MAP_TYPE_HASH,
	.key_size = sizeof(u64),
	.value_size = sizeof(u64),
	.max_entries = 4096,
};

struct bpf_map_def SEC("maps") infree_map = {
	.type = BPF_MAP_TYPE_HASH,
	.key_size = sizeof(u64),
	.value_size = sizeof(u64),
	.max_entries = 4096,
};

// cat /sys/kernel/debug/tracing/events/kmem/kmem_cache_alloc/format
/*
name: kmem_cache_alloc
ID: 538
format:
        field:unsigned short common_type;       offset:0;       size:2; signed:0;
        field:unsigned char common_flags;       offset:2;       size:1; signed:0;
        field:unsigned char common_preempt_count;       offset:3;       size:1; signed:0;
        field:int common_pid;   offset:4;       size:4; signed:1;

        field:unsigned long call_site;  offset:8;       size:8; signed:0;
        field:const void * ptr; offset:16;      size:8; signed:0;
        field:size_t bytes_req; offset:24;      size:8; signed:0;
        field:size_t bytes_alloc;       offset:32;      size:8; signed:0;
        field:gfp_t gfp_flags;  offset:40;      size:4; signed:0;
*/

struct kmem_cache_alloc_context {
    __u64 pad;
    __u64 call_site;
    void* ptr;
    __u64 bytes_req;
    __u64 bytes_alloc;
    gfp_t gfp_flags;
};

/*
name: kmalloc
ID: 539
format:
	field:unsigned short common_type;	offset:0;	size:2;	signed:0;
	field:unsigned char common_flags;	offset:2;	size:1;	signed:0;
	field:unsigned char common_preempt_count;	offset:3;	size:1;	signed:0;
	field:int common_pid;	offset:4;	size:4;	signed:1;

	field:unsigned long call_site;	offset:8;	size:8;	signed:0;
	field:const void * ptr;	offset:16;	size:8;	signed:0;
	field:size_t bytes_req;	offset:24;	size:8;	signed:0;
	field:size_t bytes_alloc;	offset:32;	size:8;	signed:0;
	field:gfp_t gfp_flags;	offset:40;	size:4;	signed:0;
*/

struct kmalloc_context {
    __u64 pad;
    __u64 call_site;
    void* ptr;
    __u64 bytes_req;
    __u64 bytes_alloc;
    gfp_t gfp_flags;
};

// cat /sys/kernel/debug/tracing/events/kmem/kfree/format
/*
name: kfree
ID: 535
format:
    field:unsigned short common_type;   offset:0;   size:2; signed:0;
    field:unsigned char common_flags;   offset:2;   size:1; signed:0;
    field:unsigned char common_preempt_count;   offset:3;   size:1; signed:0;
    field:int common_pid;   offset:4;   size:4; signed:1;

    field:unsigned long call_site;  offset:8;   size:8; signed:0;
    field:const void * ptr; offset:16;  size:8; signed:0;
*/

struct kfree_context {
    __u64 pad;
    __u64 call_site;
    void* ptr;
};

// alloc_netdev_mqs
#define ALLOCNUM 5
bool is_target_alloc_site(unsigned long curr_ip) {
	unsigned long alloc_site_array[ALLOCNUM] = {
        0xffffffff81bac818, // vlan_group_prealloc_vid net/8021q/vlanc.c:70
        0xffffffff819bb6e1, // alloc_netdev_mqs net/core/dev.c:8410
        0xffffffff819bb88d,
        0xffffffff819bb92d,
        // 0xffffffff82b42607, // nr_proto_init net/netrom/af_netrom.c:1394
        // init_x25_asy drivers/net/wan/x25_asy.c:771
        0xffffffff82b39040, // slip_init drivers/net/slip/slip.c:1296
        // 0xffffffff82b3242c, // slcan_init drivers/net/can/slcan.c:718
	};
	int cnt = 0;
	for (cnt = 0; cnt < ALLOCNUM; cnt++) {
		if (curr_ip == alloc_site_array[cnt])
			return true;
	}
	return false;
}

SEC("kprobe/kvmalloc_node")
int probe_kvmalloc_node(struct pt_regs *ctx)
{

	unsigned long alloc_addr = 0;
	unsigned long alloc_size = 0;

	long ip = 0;
	BPF_KPROBE_READ_RET_IP(ip, ctx);

	// overhead statistics
	// u64 start_time = bpf_ktime_get_ns();
	
	if (is_target_alloc_site(ip)) {

		alloc_size = PT_REGS_PARM1(ctx);
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

	/* overhead statistics
	u64 end_time = bpf_ktime_get_ns();
	u64 delta = end_time - start_time;
	value = bpf_map_lookup_elem(&bpf_duration_map, &loc);
	if (value)
		*value = delta;
	else
		bpf_map_update_elem(&bpf_duration_map, &loc, &delta, BPF_ANY);
	*/

	return 0;
}

SEC("tracepoint/kmem/kmalloc")
int probe___kmalloc(struct kmalloc_context *ctx)
{
        unsigned long alloc_addr = 0;
        unsigned long alloc_size = 0;

        long ip = ctx->call_site;

        // overhead statistics
        // u64 start_time = bpf_ktime_get_ns();

        if (is_target_alloc_site(ip)) {

                alloc_size = ctx->bytes_req;
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

        return 0;
}

SEC("tracepoint/kmem/kmem_cache_alloc")
int probe_kmem_cache_alloc_trace(struct kmem_cache_alloc_context *ctx)
{
        unsigned long alloc_addr = 0;
        unsigned long alloc_size = 0;

        long ip = ctx->call_site;

        // overhead statistics
        // u64 start_time = bpf_ktime_get_ns();

        if (is_target_alloc_site(ip)) {

                alloc_size = ctx->bytes_req;
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

        return 0;

}

SEC("tracepoint/kmem/kfree")
int probe_kfree(struct kfree_context* ctx) 
{
	unsigned long alloc_addr = (unsigned long)ctx->ptr;
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
