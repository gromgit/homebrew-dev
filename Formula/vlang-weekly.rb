class VlangWeekly < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/refs/tags/weekly.2025.24.tar.gz"
  sha256 "80e4de2d867277e5d752ebb6e7139fe4c7edba16f76a37f0a044dbe7f6ea267a"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
    regex(/weekly\.(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/gromgit/dev"
    sha256                               arm64_sonoma: "49b02fb497f05f14071793898eb65367010c2d5ec6fdee1d90a0e084499fdb77"
    sha256 cellar: :any,                 ventura:      "1ed9031a32d0c73d62914aa1e23dbb1825fe434259879925348b36cf6ee0a1fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e00cd4e407c170aca357306daee6d3e1f1b5bf34823d73a0479be1a00a5babe0"
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
