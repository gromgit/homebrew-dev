class Codon < Formula
  desc "High-performance, zero-overhead, extensible Python compiler using LLVM"
  homepage "https://docs.exaloop.io/codon"
  url "https://github.com/exaloop/codon/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "47c060b7ffacca4342970547c6e3befa0d2dcfc822449e7ffcc0daaec9e83a2f"
  license "BUSL-1.1"

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/codon-0.16.0"
    sha256 cellar: :any, arm64_monterey: "175718b71a64c59a8d3e2f8ab09988524cc834e26b027228f372dc96eeee980b"
    sha256 cellar: :any, big_sur:        "0e67ed930e92f13fc35a6e036c9091e16c063d6b64babbfdd5f37e45c31fc201"
  end

  depends_on "cmake" => :build
  depends_on "gromgit/dev/codon-llvm" => :build
  depends_on "ninja" => :build

  depends_on "cpp-peglib"
  depends_on "gcc"
  depends_on "libomp"

  def install
    ENV["CODON_SYSTEM_LIBRARIES"] = Formula["gcc"].opt_lib/"gcc/current"
    ENV.append "LDFLAGS", "-L#{Formula["libomp"].opt_lib} -lomp"
    ENV.append "CPPFLAGS", "-I#{Formula["libomp"].opt_include}"

    llvm_cmakedir = Utils.safe_popen_read(Formula["gromgit/dev/codon-llvm"].bin/"llvm-config", "--cmakedir").strip
    args = %W[
      -DCMAKE_BUILD_TYPE=Release
      -DLLVM_DIR=#{llvm_cmakedir}
      -DCMAKE_C_COMPILER=clang
      -DCMAKE_CXX_COMPILER=clang++
      -DHOMEBREW_ALLOW_FETCHCONTENT=ON
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
