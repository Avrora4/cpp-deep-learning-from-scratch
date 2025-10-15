#include <stdio.h>

__global__ void add(int *a, int *b, int *c)
{
    *c = *a + *b;
}

int main()
{
    int a = 2;
    int b = 7;
    int c;
    int *d_a, *d_b, *d_c;

    // Allocate device memory
    cudaMalloc((void**)&d_a, sizeof(int));
    cudaMalloc((void**)&d_b, sizeof(int));
    cudaMalloc((void**)&d_c, sizeof(int));

    // Copy inputs to device
    cudaMemcpy(d_a, &a, sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, &b, sizeof(int), cudaMemcpyHostToDevice);
    
    // Launch kernel
    add<<<1,1>>>(&a,&b,&c);

    // Copy result back to host
    cudaMemcpy(&c, d_c, sizeof(int), cudaMemcpyDeviceToHost);

    printf("Result: %d\n", c);

    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);

    return 0;
}