all: poc.c bench.c
	gcc -o poc poc.c -pthread -static
	gcc -o bench bench.c -pthread -static
clean:
	-rm poc bench
