class CodonLlvm < Formula
  desc "Custom LLVM required to build Codon"
  homepage "https://github.com/exaloop/llvm-project"
  url "https://github.com/exaloop/llvm-project.git",
      tag:      "codon-15.0.1",
      revision: "7ea1b7bf4fca5bef3d14b46192257d195c9ba422"
  version "2023.09.18"
  license "BUSL-1.1"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/dev"
    sha256 cellar: :any,                 arm64_sonoma: "682fc14767a5c3a8c8fcc17b63ca17428493aace7fe7ec3fa74ba1ef5d7412df"
    sha256 cellar: :any,                 ventura:      "7fa9a8c8c1c4e63ee55ef8bc7b7b9ac3c4e939da17e0b9e27f2421fbfe74ff3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5ada579c04e71c9fd72961989b6aa0946703d0e8286125a1d6d9246df0513a56"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "python@3.13" => :build

  def install
    args = %w[
      -DCMAKE_BUILD_TYPE=Release
      -DLLVM_INCLUDE_TESTS=OFF
      -DLLVM_ENABLE_PROJECTS=clang
      -DLLVM_ENABLE_RTTI=ON
      -DLLVM_ENABLE_ZLIB=OFF
      -DLLVM_ENABLE_TERMINFO=OFF
      -DLLVM_ENABLE_LIBXML2=OFF
      -DLLVM_ENABLE_LIBEDIT=OFF
      -DLLVM_ENABLE_ZSTD=OFF
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
