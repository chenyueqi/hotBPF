/*
 * Software Name: hotbpf
 * Author: Yueqi Chen <yueqichen.0x0@gmail.com>
 *		   Zicheng Wang <wangzccs@gmail.com>
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <string.h>
#include <errno.h>
#include <sys/resource.h>
#include <bpf/libbpf.h>
#include <fcntl.h>

#define VMALLOC_FREE_PATH "/proc/vmalloc_free"

static volatile sig_atomic_t stop;

static void sig_int(int signo)
{
	stop = 1;
}



int main(int argc, char **argv)
{
    struct bpf_link *links[2];
	struct bpf_program *prog;
	struct bpf_object *obj;
	char filename[256];
	int map_fd[3], i, j = 0;
	int vmalloc_fd = 0;
	__u64 key, next_key, val;
	int trace_fd;
	
	trace_fd = open("/sys/kernel/debug/tracing/trace_pipe", O_RDONLY, 0);
	if (trace_fd < 0) {
		printf("cannot open trace_pipe %d\n", trace_fd);
		return trace_fd;
	}

	// vmalloc_fd = open(VMALLOC_FREE_PATH, O_WRONLY);
    // if (vmalloc_fd == -1) {
    //     perror("Failed to open " VMALLOC_FREE_PATH);
    //     exit(EXIT_FAILURE);
    // }

    snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
	
	obj = bpf_object__open_file(filename, NULL);
	if (libbpf_get_error(obj)) {
		fprintf(stderr, "ERROR: opening BPF object file failed\n");
		return 0;
	}

	/* load BPF program */
	if (bpf_object__load(obj)) {
		fprintf(stderr, "ERROR: loading BPF object file failed\n");
		goto cleanup;
	}

	map_fd[0] = bpf_object__find_map_fd_by_name(obj, "addr2key");
	if (map_fd[0] < 0) {
		fprintf(stderr, "ERROR: finding a map in obj file failed\n");
		goto cleanup;
	}

	map_fd[1] = bpf_object__find_map_fd_by_name(obj, "key2cache");
	if (map_fd[1] < 0) {
		fprintf(stderr, "ERROR: finding a map in obj file failed\n");
		goto cleanup;
	}

	// map_fd[2] = bpf_object__find_map_fd_by_name(obj, "chunk_pool_map");
	// if (map_fd[2] < 0) {
	// 	fprintf(stderr, "ERROR: finding a map in obj file failed\n");
	// 	goto cleanup;
	// }

	bpf_object__for_each_program(prog, obj) {
		links[j] = bpf_program__attach(prog);
		if (libbpf_get_error(links[j])) {
			fprintf(stderr, "ERROR: bpf_program__attach failed\n");
			links[j] = NULL;
			goto cleanup;
		}
		j++;
	}

	if (signal(SIGINT, sig_int) == SIG_ERR) {
		fprintf(stderr, "can't set signal handler: %s\n", strerror(errno));
		goto cleanup;
	}

    printf("Please run `sudo cat /sys/kernel/debug/tracing/trace_pipe` "
	       "to see output of the BPF programs.\n");

	
	printf("start tracing\n");
    while (!stop) {
        // fprintf(stderr, ".");
        // sleep(1);
		static char buf[4096];
		ssize_t sz;
		sz = read(trace_fd, buf, sizeof(buf) - 1);
		if (sz > 0) {
			buf[sz] = '\0';
			// printf("trace: %s\n", buf);
			puts(buf);
		}
    }


    cleanup:
        // bpf_link__destroy(link);
		printf("\nprint addr2key\n");
		int count = 0;
		while (bpf_map_get_next_key(map_fd[0], &key, &next_key) == 0) {
			bpf_map_lookup_elem(map_fd, &next_key, &val);
			key = next_key;
			printf("%5d:%016llx:%016llx\n", ++count, key, val);
		}
		
		key = 0;
		printf("\nprint key2cache\n");
		count = 0;
		while (bpf_map_get_next_key(map_fd[1], &key, &next_key) == 0) {
			bpf_map_lookup_elem(map_fd, &next_key, &val);
			key = next_key;
			printf("%5d:%016llx:%016llx\n", ++count, key, val);
		}

		key = 0;
		// printf("\nprint chunk_pool\n");
		// count = 0;
		// while (bpf_map_get_next_key(map_fd[2], &key, &next_key) == 0) {
		// 	bpf_map_lookup_elem(map_fd, &next_key, &val);
		// 	key = next_key;
		// 	if (write(vmalloc_fd, &key, sizeof(key)) == -1) {
		// 		perror("Failed to write to " VMALLOC_FREE_PATH);
		// 		close(vmalloc_fd);
		// 		exit(EXIT_FAILURE);
		// 	}
		// 	printf("%5d:%016llx:%016llx\n", ++count, key, val);
		// }


		for (j--; j >= 0; j--)
			bpf_link__destroy(links[j]);
	    bpf_object__close(obj);

		// close(vmalloc_fd);
		close(trace_fd);
        return 0;




    return 0;
}