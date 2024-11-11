#include <stdio.h>

/*
 * Check if a number is a Fibonacci number
 */
__device__ bool isFib(int s) {
    int a = 0, b = 1, c = 0;

    if (s == 0 || s == 1) return true;

    while (c < s) {
        c = a + b;
        a = b;
        b = c;
    }
    return c == s;
}

/*
 * Show DIMs & IDs for grid, block and thread
 */
__global__ void checkIndex(void) {

  int s = threadIdx.x * blockDim.x + threadIdx.y * blockDim.y + blockIdx.x + blockIdx.y;
  
  if (isFib(s)) {
      printf("threadIdx: (%d, %d)  blockIdx: (%d, %d) \nblockDim: (%d, %d)  gridDim: (%d, %d)\n\n", 
             threadIdx.x, threadIdx.y, blockIdx.x, blockIdx.y, 
             blockDim.x, blockDim.y, gridDim.x, gridDim.y);
  }
}

int main(int argc, char **argv) {

    // grid and block structure
    dim3 block(7, 6);
    dim3 grid(2, 2);

    // Print from host
    printf("Print from host:\n");
    printf("grid.x = %d\t grid.y = %d\t grid.z = %d\n", grid.x, grid.y, grid.z);
    printf("block.x = %d\t block.y = %d\t block.z %d\n\n", block.x, block.y, block.z);

    // Print from device
    printf("Print from device:\n");
    checkIndex<<<grid, block>>>();

    // Ensure all threads complete
    cudaDeviceSynchronize();

    // reset device
    cudaDeviceReset();
    return 0;
}
