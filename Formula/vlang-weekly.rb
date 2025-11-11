class VlangWeekly < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/refs/tags/weekly.2025.46.tar.gz"
  sha256 "2a3345c1dfbb63fa720f5c6faac9a55c8bb564cf96ae2e98ad54f35c7abdb0cf"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
    regex(/weekly\.(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/gromgit/dev"
    sha256                               arm64_tahoe:   "93d15090f4e6506d845f8eab9956cdc95ac7f3422fc07a8bb72fb4877514681c"
    sha256                               arm64_sequoia: "b40f4117344bb3e62a3298a8f3349911e7680cfebc8f01931c3cb66f57f608b6"
    sha256                               arm64_sonoma:  "6d6f40b12ad142321f9997eda7b0a83af449b7572f7e882b7a5113724c0b29aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49ca1afa7b71761beb9d551361a44d12873d7f7c10b8e73b5529c1c4bd455bf8"
  end

  depends_on "pkgconf" => :build
  depends_on "bdw-gc"
  on_linux do
    depends_on "libx11"
  end

  conflicts_with "vlang", because: "both install `v` binaries"

  def install
    %w[up self].each do |cmd|
      (buildpath/"cmd/tools/v#{cmd}.v").delete
      (buildpath/"cmd/tools/v#{cmd}.v").write <<~EOS
        println('ERROR: `v #{cmd}` is disabled. Use `brew upgrade #{name}` to update V.')
      EOS
    end

    system "make"
    system "./v", "-showcc", "-v", "-prod", "-d", "dynamic_boehm", "-o", "v", "cmd/v"
    system "./v", "-showcc", "-v", "-prod", "-d", "dynamic_boehm", "build-tools"

    # clean up unnecessary stuff
    %w[thirdparty/tcc/.git].each { |d| rm_r(buildpath/d) }
    (buildpath/"cmd/tools/.disable_autorecompilation").write <<~EOS
      This is just a placeholder to tell V not to recompile any of its own tools.
    EOS

    libexec.install "cmd", "thirdparty", "v", "v.mod", "vlib"
    bin.install_symlink libexec/"v"
    pkgshare.install "bench", "examples", "tutorials"
    doc.install Dir["doc/*"]
  end

  test do
    cp pkgshare/"examples/hello_world.v", testpath
    system bin/"v", "-o", "test", "hello_world.v"
    assert_equal "Hello, World!", shell_output("./test").chomp
  end
end
