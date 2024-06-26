#pragma once

__global__ void imageNegativeKernel(unsigned char *inp, unsigned char *out, const uint N, const uint L = 255) {
    uint idx = threadIdx.x + blockDim.x * blockIdx.x;
    const uint stride = gridDim.x * blockDim.x;

    while(idx < N) {
        out[idx] = L - inp[idx];
        idx += stride;
    }
}

__global__ void logTransformKernel(unsigned char *inp, unsigned char *out, const uint N, const int L = 255) {
    uint idx = threadIdx.x + blockDim.x * blockIdx.x;
    const uint stride = gridDim.x * blockDim.x;

    while(idx < N) {
        const unsigned char tmp = static_cast<u_char>(L  * logf(1 + inp[idx]) / logf(L + 1));
        out[idx] = tmp;
        idx += stride;
    }
}

__global__ void gammaTransformKernel(unsigned char *inp, unsigned char *out, const uint N, const int C = 1, const float gamma = 1) {
    uint idx = threadIdx.x + blockDim.x * blockIdx.x;
    const uint stride = gridDim.x * blockDim.x;

    while(idx < N) {
        float tmp = static_cast<float>(inp[idx]) / 255.0;
        tmp = C * powf(tmp, gamma) * 255;
        out[idx] = static_cast<unsigned char>(tmp);
        idx += stride;
    }
}