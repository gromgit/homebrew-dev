class VlangWeekly < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/refs/tags/weekly.2025.39.tar.gz"
  sha256 "a0296e9f0f72d101c75d17be0cf7e70a69a04c2cb4564fb058cf3d9273edb386"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
    regex(/weekly\.(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/gromgit/dev"
    sha256                               arm64_sequoia: "2b5894f8cd440d40ff09902e51054ce8ca544df1949fc1a8547a245d0136984c"
    sha256                               arm64_sonoma:  "4af3a1c63840da004af0103266b2875207f4de92b5cf516840bda0e00e5d6652"
    sha256 cellar: :any,                 ventura:       "25868e5c6b42601f122de0696624a8c10b03be8f111b87ac4acdf6bc0bf197d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdc2e89e39dae1937648884b004921cba711bf4d2a7144e78f7ee61811906739"
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
