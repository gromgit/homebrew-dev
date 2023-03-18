class Codon < Formula
  desc "High-performance, zero-overhead, extensible Python compiler using LLVM"
  homepage "https://docs.exaloop.io/codon"
  url "https://github.com/exaloop/codon/archive/refs/tags/v0.15.5.tar.gz"
  sha256 "f17e79800c50adf5bf58cc4d374ef4304455011454cda37d3a2d9e837677f2ae"
  license "BUSL-1.1"

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/codon-0.15.5"
    sha256 cellar: :any, arm64_monterey: "12a348759f27b4853a907f5292464fb5a1228b9280dc5c1a422a6ed55bc26c03"
    sha256 cellar: :any, monterey:       "9f9b2d74d23777f42fab806b9f089afa613ced898deba0ca9a7620fd1d52cdc1"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  # Codon uses a custom LLVM fork
  resource "llvm-project" do
    url "https://github.com/exaloop/llvm-project.git",
        tag:      "codon",
        revision: "55b0b8fa1c9f9082b535628fc9fa6313280c0b9a"
  end

  def install
    resource("llvm-project").stage do
      args = %w[
        -DCMAKE_BUILD_TYPE=Release
        -DLLVM_INCLUDE_TESTS=OFF
        -DLLVM_ENABLE_RTTI=ON
        -DLLVM_ENABLE_ZLIB=OFF
        -DLLVM_ENABLE_TERMINFO=OFF
        -DLLVM_TARGETS_TO_BUILD=all
      ]
      system "cmake", "-S", "llvm", "-B", "build", "-G", "Ninja",
                      *args, *std_cmake_args(install_prefix: libexec/"llvm")
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    llvm_cmakedir = Utils.safe_popen_read(libexec/"llvm/bin/llvm-config", "--cmakedir").strip
    args = %W[
    -DCMAKE_BUILD_TYPE=Release
    -DLLVM_DIR=#{llvm_cmakedir}
    -DCMAKE_C_COMPILER=clang
    -DCMAKE_CXX_COMPILER=clang++
    ]
    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja",
                    *args, *std_cmake_args
    system "cmake", "--build", "build", "--config", "Release"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"fib.py").write <<~EOS
      def fib(n):
          a, b = 0, 1
          while a < n:
              print(a, end=' ')
              a, b = b, a+b
          print()
      fib(1000)
    EOS
    system bin/"codon", "build", "-release", "-exe", testpath/"fib.py"
    assert_equal "0 1 1 2 3 5 8 13 21 34 55 89 144 233 377 610 987 ", shell_output(testpath/"fib").chomp
  end
end
