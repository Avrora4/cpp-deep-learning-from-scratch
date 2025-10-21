
// Kernel denition
#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>

#define CUDA_CHECK(call)\
    do\
    {\
        cudaError_t err = (call);\
        if(err != cudaSuccess)\
        {\
            fprintf(stderr, "CUDA error %s:%d: %s\n", __FILE__, __LINE__,cudaGetErrorString(err));\
            exit(EXIT_FAILURE);\
        }\
    } while (0)\

__global__ void MatAdd(const float *A, const float *B, float *C, int N)
{
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;
    if(row< N && col < N)
    {
        int idx = row * N + col;
        C[idx] = A[idx] + B[idx];
    }
    // C[i][j] = A[i][j] + B[i][j];
}

int main()
{
    // float *A, *B, *C;
    int N = 16;
    size_t bytes = (size_t)N * N * sizeof(float);

    float *hA = (float*)malloc(bytes);
    float *hB = (float*)malloc(bytes);
    float *hC = (float*)malloc(bytes);
    if(!hA || !hB || !hC)
    {
        fprintf(stderr, "Failed to allocate host vectors!\n");
        exit(EXIT_FAILURE);
    }
    for (int i = 0; i < N * N; ++i)
    {
        hA[i] = 1.0f * i;
        hB[i] = 2.0f * i;
    }

    // Allocate memory on device
    /*
    cudaMalloc((void**)&A, N*N*sizeof(float));
    cudaMalloc((void**)&B, N*N*sizeof(float));
    cudaMalloc((void**)&C, N*N*sizeof(float));
    float *a = malloc(N*N*sizeof(float));
    float *b = malloc(N*N*sizeof(float));
    float *c = malloc(N*N*sizeof(float));
    */

    float *dA = NULL;
    float *dB = NULL;
    float *dC = NULL;
    CUDA_CHECK(cudaMalloc((void**)&dA, bytes));
    CUDA_CHECK(cudaMalloc((void**)&dB, bytes));
    CUDA_CHECK(cudaMalloc((void**)&dC, bytes));

    CUDA_CHECK(cudaMemcpy(dA, hA, bytes, cudaMemcpyHostToDevice));
    CUDA_CHECK(cudaMemcpy(dB, hB, bytes, cudaMemcpyHostToDevice));


    // cudaMemcpy(A, a, N * N * sizeof(*A), cudaMemcpyHostToDevice);
    // cudaMemcpy(B, b, N * N * sizeof(*B), cudaMemcpyHostToDevice);

    // kernel invocation with one block of N * N * 1 threads
    // int numBlocks = 1;
    dim3 threadsPerBlock(16, 16);
    dim3 numBlocks((N + threadsPerBlock.x - 1) / threadsPerBlock.x, 
                   (N + threadsPerBlock.y - 1) / threadsPerBlock.y);
    MatAdd<<<numBlocks, threadsPerBlock>>>(dA, dB, dC, N);

    // runtime error check
    CUDA_CHECK(cudaGetLastError());
    CUDA_CHECK(cudaDeviceSynchronize());

    // Device -> Host copy
    CUDA_CHECK(cudaMemcpy(hC, dC, bytes, cudaMemcpyDeviceToHost));

    // results (Header 4 * 4)
    for (int r = 0; r < 4 && r < N; ++r)
    {
        for (int c = 0; c < 4 && c < N; ++c)
        {
            printf("%8.1f ", hC[r * N + c]);
        }
        printf("\n");
    }

    // cudaMecpy(c, C, N * N * sizeof(*c), cudaMemcpyDeviceToHost);

    // free device memory
    CUDA_CHECK(cudaFree(dA));
    CUDA_CHECK(cudaFree(dB));
    CUDA_CHECK(cudaFree(dC));
    free(hA);
    free(hB);
    free(hC);

    return 0;

}