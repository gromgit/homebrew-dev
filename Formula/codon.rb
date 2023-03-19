class Codon < Formula
  desc "High-performance, zero-overhead, extensible Python compiler using LLVM"
  homepage "https://docs.exaloop.io/codon"
  url "https://github.com/exaloop/codon/archive/refs/tags/v0.15.5.tar.gz"
  sha256 "f17e79800c50adf5bf58cc4d374ef4304455011454cda37d3a2d9e837677f2ae"
  revision 2
  license "BUSL-1.1"

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/codon-0.15.5"
    sha256 cellar: :any, arm64_monterey: "8697937cac4d9fe46e1f445d400c039a512c0b300f8b11eab0850aa19137413f"
    sha256 cellar: :any, big_sur:        "6bb78345d7eabc5ec9434d009bf0e1327ebfff5c4c9d0467cc8d78bd0310d6e1"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "gromgit/dev/codon-llvm" => :build

  def install
    llvm_cmakedir = Utils.safe_popen_read(Formula["gromgit/dev/codon-llvm"].bin/"llvm-config", "--cmakedir").strip
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
