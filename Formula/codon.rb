class Codon < Formula
  desc "High-performance, zero-overhead, extensible Python compiler using LLVM"
  homepage "https://docs.exaloop.io/codon"
  url "https://github.com/exaloop/codon/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "9b02e270d1c1a684667a57291987c376aef9fc1730cf5b2c44a36f6dbc26bdcb"
  license "BUSL-1.1"

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/codon-0.16.0"
    sha256 cellar: :any, arm64_monterey: "175718b71a64c59a8d3e2f8ab09988524cc834e26b027228f372dc96eeee980b"
  end

  depends_on "cmake" => :build
  depends_on "gromgit/dev/codon-llvm" => :build
  depends_on "ninja" => :build

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
