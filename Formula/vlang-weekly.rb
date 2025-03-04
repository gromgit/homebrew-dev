class VlangWeekly < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/refs/tags/weekly.2025.10.tar.gz"
  sha256 "80a2542819e9ef594994ac89b589e776af4647d501248ea30db88914ec1c7c32"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
    regex(/weekly\.(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/gromgit/dev"
    sha256                               arm64_sonoma: "f26304cf2c6570a5a7d71a62ff45e2938bd1efd353b8c1246f08ebd87c3942e4"
    sha256 cellar: :any_skip_relocation, ventura:      "ac0fe563a29f53b1df9731fff0b5fcf503787ba5a0be5699e61940300b5fe939"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a7ccf60e3ef3ea7ffd43465839bef9a3e2dfe32a30143432d165da92d87fb6be"
  end

  depends_on "bdw-gc" => :build
  on_linux do
    depends_on "libx11"
  end

  conflicts_with "vlang", because: "both install `v` binaries"

  def install
    # inreplace "vlib/builtin/builtin_d_gcboehm.c.v", "@PREFIX@", Formula["bdw-gc"].opt_prefix
    %w[up self].each do |cmd|
      (buildpath/"cmd/tools/v#{cmd}.v").delete
      (buildpath/"cmd/tools/v#{cmd}.v").write <<~EOS
        println('ERROR: `v #{cmd}` is disabled. Use `brew upgrade #{name}` to update V.')
      EOS
    end

    system "make"
    system "./v", "-prod", "-o", "v", "cmd/v"
    system "./v", "-prod", "build-tools"

    # clean up unnecessary stuff
    %w[thirdparty/tcc/.git].each { |d| rm_r(buildpath/d) }
    (buildpath/"cmd/tools/.disable_autorecompilation").write <<~EOS
      This is just a placeholder to tell V not to recompile any of its own tools.
    EOS

    libexec.install "cmd", "thirdparty", "v", "v.mod", "vlib"
    bin.install_symlink libexec/"v"
    pkgshare.install "examples", "tutorials"
    doc.install Dir["doc/*"]
  end

  test do
    cp pkgshare/"examples/hello_world.v", testpath
    system bin/"v", "-o", "test", "hello_world.v"
    assert_equal "Hello, World!", shell_output("./test").chomp
  end
end
