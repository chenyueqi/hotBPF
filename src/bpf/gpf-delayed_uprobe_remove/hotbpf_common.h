/*
 * Software Name: hotbpf
 * Author: Yueqi Chen <yueqichen.0x0@gmail.com>
 */

#ifndef HOTBPF_COMMON_H
#define HOTBPF_COMMON_H

enum {
    HOTBPF_PROG_KPROBE_BPF_PROG3 = 0,
    HOTBPF_PROG_KPROBE_MAX
};

// print message to file *\/sys/kernel/debug/tracing/trace* from DebugFS
#define bpf_printk(fmt, ...)				\
({							\
	char ____fmt[] = fmt;				\
	bpf_trace_printk(____fmt, sizeof(____fmt),	\
			 ##__VA_ARGS__);		\
})

#endif
