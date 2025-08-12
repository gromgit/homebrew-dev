class VlangWeekly < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/refs/tags/weekly.2025.33.tar.gz"
  sha256 "1460364ce0f6f8731f749fa82a0c3fe923c1988e8571db32e6e1c07ea125a348"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
    regex(/weekly\.(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/gromgit/dev"
    sha256                               arm64_sequoia: "02d80a8015def144620acb4870e7d05bfabcaa8880ceb7a493c7cb1249222dcc"
    sha256                               arm64_sonoma:  "3fb9a569230cb570906b4172bdd98631da2ab1f8c668778a21a26a6adb80d275"
    sha256 cellar: :any,                 ventura:       "40b9a9aa3a34c3b1ef107e06b013bd3f69dbe6d83050bd8e7ba717bd2bb6da5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95227da6ff3dc8997400b2e0b819cc8524a4cdefcee99dac15284f268c172918"
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
