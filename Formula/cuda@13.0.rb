class CudaAT130 < Formula
  # CUDA version variables
  CUDA_VERSION = "13.0.1".freeze
  CUDA_BUILD = "580.82.07".freeze
  CUDA_A64_SHA = "927e2c2a6a3e0d12e7e93df10dad6d8f3c688b9e27e9d2034f82d437ec2d2666".freeze
  CUDA_X64_SHA = "4c7ac59d1f41d67be27d140a4622801738ad71088570a0facfd6ec878a4c4100".freeze
  CUDA_MIN_ARCH = 75

  desc "NVIDIA's GPU programming toolkit"
  homepage "https://developer.nvidia.com/cuda-toolkit"

  license :cannot_represent
  keg_only "it contains hardcoded relative paths that aren't handled by Homebrew"

  option "without-man", "Install without man pages"

  depends_on "gcc@14"
  depends_on :linux

  if Hardware::CPU.arm?
    url "https://developer.download.nvidia.com/compute/cuda/#{CUDA_VERSION}/local_installers/cuda_#{CUDA_VERSION}_#{CUDA_BUILD}_linux_sbsa.run", using: :nounzip
    sha256 CUDA_A64_SHA
  else
    url "https://developer.download.nvidia.com/compute/cuda/#{CUDA_VERSION}/local_installers/cuda_#{CUDA_VERSION}_#{CUDA_BUILD}_linux.run", using: :nounzip
    sha256 CUDA_X64_SHA
  end

  def install
    cuda_run = File.basename stable.url

    args = %W[
      --silent
      --toolkit
      --installpath=#{prefix}
      --no-opengl-libs
      --no-drm
    ]
    args += %w[--no-man-page] if build.without? "man"

    require "pty"
    PTY.spawn("sh", cuda_run, *args) do |r, _, pid|
      output = r.read
    rescue Errno::EIO, EOFError
      # GNU/Linux raises EIO when read is done on closed pty
    ensure
      (logs/"#{cuda_run}.log").write output
      r.close
      Process.wait(pid)
    end

    # clean up binaries for other architectures
    rm_r prefix.glob("**/x86")
    rm_r prefix.glob("**/*-x86")
    if Hardware::CPU.arm?
      rm_r prefix.glob("**/*-x64")
    else
      rm_r prefix.glob("**/*-a64")
    end
  end

  test do
    ENV.prepend_path "PATH", Formula["cuda@13.0"].opt_bin

    # run the nvcc command to check if CUDA is installed correctly
    output = shell_output("nvcc --version")
    assert_match "Cuda compilation tools, release #{version.major_minor}", output

    # compile test cribbed from FFMPEG
    (testpath/"test.cu").write <<~EOS
      extern "C" {
          __global__ void hello(unsigned char *data) {}
      }
    EOS
    testcu_args = %W[
      -gencode arch=compute_#{CUDA_MIN_ARCH},code=sm_#{CUDA_MIN_ARCH}
      -O2 -std=c++11 -m64 -ptx
    ]
    system "nvcc", *testcu_args, "-c", "-o", "test.o", "test.cu"

    # try an actual CUDA program
    # original: https://gist.githubusercontent.com/f0k/0d6431e3faa60bffc788f8b4daa029b1/raw/8c38eadc9d81a957e5df5963bda8c4ab3271b664/cuda_check.c
    (testpath/"cuda_check.c").write <<~'EOS'
      #include <stdio.h>
      #include <cuda.h>
      #include <cuda_runtime_api.h>

      /* Outputs some information on CUDA-enabled devices on your computer,
       * including compute capability and current memory usage.
       *
       * On Linux, compile with: nvcc -o cuda_check cuda_check.c -lcuda
       * On Windows, compile with: nvcc -o cuda_check.exe cuda_check.c -lcuda
       *
       * Authors: Thomas Unterthiner, Jan Schlüter
       */

      int ConvertSMVer2Cores(int major, int minor)
      {
        // Returns the number of CUDA cores per multiprocessor for a given
        // Compute Capability version. There is no way to retrieve that via
        // the API, so it needs to be hard-coded.
        // See _ConvertSMVer2Cores in helper_cuda.h in NVIDIA's CUDA Samples.
        switch ((major << 4) + minor) {
          case 0x10: return 8;    // Tesla
          case 0x11: return 8;
          case 0x12: return 8;
          case 0x13: return 8;
          case 0x20: return 32;   // Fermi
          case 0x21: return 48;
          case 0x30: return 192;  // Kepler
          case 0x32: return 192;
          case 0x35: return 192;
          case 0x37: return 192;
          case 0x50: return 128;  // Maxwell
          case 0x52: return 128;
          case 0x53: return 128;
          case 0x60: return 64;   // Pascal
          case 0x61: return 128;
          case 0x62: return 128;
          case 0x70: return 64;   // Volta
          case 0x72: return 64;   // Xavier
          case 0x75: return 64;   // Turing
          case 0x80: return 64;   // Ampere
          case 0x86: return 128;
          case 0x87: return 128;
          case 0x89: return 128;  // Ada
          case 0x90: return 129;  // Hopper
          default: return 0;
        }
      }

      int main()
      {
        int nGpus;
        int i;
        char name[100];
        int cc_major, cc_minor, cores, cuda_cores, threads_per_core, clockrate;
        size_t freeMem;
        size_t totalMem;

        CUresult result;
        CUdevice device;
        CUcontext context;

        result = cuInit(0);
        if (result != CUDA_SUCCESS) {
          printf("cuInit failed with error code %d: %s\n", result, cudaGetErrorString(result));
          return 1;
        }
        result = cuDeviceGetCount(&nGpus);
        if (result != CUDA_SUCCESS) {
          printf("cuDeviceGetCount failed with error code %d: %s\n", result, cudaGetErrorString(result));
          return 1;
        }
        printf("Found %d device(s).\n", nGpus);
        for (i = 0; i < nGpus; i++) {
          cuDeviceGet(&device, i);
          printf("Device: %d\n", i);
          if (cuDeviceGetName(&name[0], sizeof(name), device) == CUDA_SUCCESS) {
            printf("  Name: %s\n", &name[0]);
          }
          if ((cuDeviceGetAttribute(&cc_major, CU_DEVICE_ATTRIBUTE_COMPUTE_CAPABILITY_MAJOR, device) == CUDA_SUCCESS) &&
              (cuDeviceGetAttribute(&cc_minor, CU_DEVICE_ATTRIBUTE_COMPUTE_CAPABILITY_MINOR, device) == CUDA_SUCCESS)) {
            printf("  Compute Capability: %d.%d\n", cc_major, cc_minor);
          }
          else {
            cc_major = cc_minor = 0;
          }
          if (cuDeviceGetAttribute(&cores, CU_DEVICE_ATTRIBUTE_MULTIPROCESSOR_COUNT, device) == CUDA_SUCCESS) {
            printf("  Multiprocessors: %d\n", cores);
            if (cc_major && cc_minor) {
              cuda_cores = cores * ConvertSMVer2Cores(cc_major, cc_minor);
              if (cuda_cores > 0) {
                printf("  CUDA Cores: %d\n", cuda_cores);
              }
              else {
                printf("  CUDA Cores: unknown\n");
              }
            }
            if (cuDeviceGetAttribute(&threads_per_core, CU_DEVICE_ATTRIBUTE_MAX_THREADS_PER_MULTIPROCESSOR, device) == CUDA_SUCCESS) {
              printf("  Concurrent threads: %d\n", cores*threads_per_core);
            }
          }
          if (cuDeviceGetAttribute(&clockrate, CU_DEVICE_ATTRIBUTE_CLOCK_RATE, device) == CUDA_SUCCESS) {
            printf("  GPU clock: %g MHz\n", clockrate/1000.);
          }
          if (cuDeviceGetAttribute(&clockrate, CU_DEVICE_ATTRIBUTE_MEMORY_CLOCK_RATE, device) == CUDA_SUCCESS) {
            printf("  Memory clock: %g MHz\n", clockrate/1000.);
          }
          cuCtxCreate(&context, NULL, 0, device);
          result = cuMemGetInfo(&freeMem, &totalMem);
          if (result == CUDA_SUCCESS ) {
            printf("  Total Memory: %ld MiB\n  Free Memory: %ld MiB\n", totalMem / ( 1024 * 1024 ), freeMem / ( 1024 * 1024 ));
          } else {
            printf("  cMemGetInfo failed with error code %d: %s\n", result, cudaGetErrorString(result));
          }
          cuCtxDestroy(context);
        }
        return 0;
      }
    EOS
    system "nvcc", "-o", "cuda_check", "cuda_check.c", "-lcuda"
    # no point running this on GitHub infrastructure
    return if ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "./cuda_check"
  end
end
