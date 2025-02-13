class CodonLlvm < Formula
  desc "Custom LLVM required to build Codon"
  homepage "https://github.com/exaloop/llvm-project"
  url "https://github.com/exaloop/llvm-project.git",
      tag:      "codon",
      revision: "55b0b8fa1c9f9082b535628fc9fa6313280c0b9a"
  version "2022.09.23"
  license "BUSL-1.1"

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/codon-llvm-2022.09.23"
    sha256 cellar: :any, arm64_monterey: "43121f4b5730a13e3770b3867dde5a965c185f8ab4f81a1878f0f4f81f0c74ce"
    sha256 cellar: :any, big_sur:        "8885ea7a5ac48bf77f04af84f7c510defae20cafd36f4ef8ca6f18fd86444981"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "python@3.11" => :build

  def install
    args = %w[
      -DCMAKE_BUILD_TYPE=Release
      -DLLVM_INCLUDE_TESTS=OFF
      -DLLVM_ENABLE_RTTI=ON
      -DLLVM_ENABLE_ZLIB=OFF
      -DLLVM_ENABLE_TERMINFO=OFF
      -DLLVM_TARGETS_TO_BUILD=all
    ]
    system "cmake", "-S", "llvm", "-B", "build", "-G", "Ninja",
                    *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    on_macos do
      <<~EOS
        To use the bundled libc++ please add the following LDFLAGS:
          LDFLAGS="-L#{opt_lib}/c++ -Wl,-rpath,#{opt_lib}/c++"
      EOS
    end
  end

  test do
    llvm_version = Version.new(Utils.safe_popen_read(bin/"llvm-config", "--version").strip)
    soversion = llvm_version.major.to_s
    soversion << "git" if head?

    assert_equal prefix.to_s, shell_output("#{bin}/llvm-config --prefix").chomp

    # Ensure LLVM did not regress output of `llvm-config --system-libs` which for a time
    # was known to output incorrect linker flags; e.g., `-llibxml2.tbd` instead of `-lxml2`.
    # On the other hand, note that a fully qualified path to `dylib` or `tbd` is OK, e.g.,
    # `/usr/local/lib/libxml2.tbd` or `/usr/local/lib/libxml2.dylib`.
    shell_output("#{bin}/llvm-config --system-libs").chomp.strip.split.each do |lib|
      if lib.start_with?("-l")
        assert !lib.end_with?(".tbd"), "expected abs path when lib reported as .tbd"
        assert !lib.end_with?(".dylib"), "expected abs path when lib reported as .dylib"
      else
        p = Pathname.new(lib)
        e = [".tbd", ".dylib"]
        assert p.absolute?, "expected abs path when lib reported as .tbd or .dylib" if e.include?(p.extname)
      end
    end
  end
end
