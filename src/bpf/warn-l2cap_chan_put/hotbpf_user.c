/*
 * Software Name: hotbpf
 * Author: Yueqi Chen <yueqichen.0x0@gmail.com>
 */

#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <signal.h>
#include <time.h>
#include <assert.h>
#include <errno.h>
#include <sys/resource.h>
// #include <linux/if_link.h>
#include <linux/limits.h>

#include <linux/bpf.h>
#include <bpf/bpf.h>
#include <bpf/libbpf.h>
#include "bpf_load.h"

#include "hotbpf_common.h"

struct bpf_progs_desc {
    char name[256];
    enum bpf_prog_type type;
    unsigned char pin;
    int map_prog_idx;
    struct bpf_program *prog;
};

static int print_bpf_verifier(const char *format, va_list args)
{
    return vfprintf(stdout, format, args);
}

int main(int argc, char * argv[]) 
{
    struct rlimit r = {RLIM_INFINITY, RLIM_INFINITY};
    char filename[PATH_MAX];

    snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);

    sigset_t signal_mask;
    sigemptyset(&signal_mask);
    sigaddset(&signal_mask, SIGINT);
    sigaddset(&signal_mask, SIGTERM);
    sigaddset(&signal_mask, SIGUSR1);

    if (setrlimit(RLIMIT_MEMLOCK, &r)) {
        perror("setrlimit failed");
        return 1;
    }

    libbpf_set_print(print_bpf_verifier);

    // load program and maps
    if (load_bpf_file(filename)) {
        fprintf(stderr, "Error: load_bpf_file failed\n");
        return 1;
    }

    while(1){
    	sleep(1000);
    }
}
