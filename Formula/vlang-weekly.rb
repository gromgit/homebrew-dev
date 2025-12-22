class VlangWeekly < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/refs/tags/weekly.2025.52.tar.gz"
  sha256 "0df8620109ca53ae03725de58cd3e8d55a0a7939c7d7d475a1c1f629ae2bb11d"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
    regex(/weekly\.(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/gromgit/dev"
    sha256                               arm64_tahoe:   "14ad52e885a161b9be4a03b9cdf7d833a170b9a97f182ce08b2b34dfb41a8b4e"
    sha256                               arm64_sequoia: "cfb1f85aa615df4342ed8d8c9d32aa7374d0d07337a02d1c037f9925f814aa56"
    sha256                               arm64_sonoma:  "01558bae40606b71bd85a3eaa209fb901972c414e8d460bc398959133e862f41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac79463d20c6c4b69191cb948d5b459c0f74f7fb7bc115700e9c88b1afedc5ff"
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
