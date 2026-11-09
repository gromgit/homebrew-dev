class MintLang < Formula
  desc "Programming language for single-page web applications"
  homepage "https://www.mint-lang.com/"
  url "https://github.com/mint-lang/mint/archive/refs/tags/0.29.0.tar.gz"
  sha256 "ac74611b1cf4737ab00e255ccdf64c9c21fb88d1a76157f54b83126416ff3113"
  license "BSD-3-Clause"

  head "https://github.com/mint-lang/mint.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/dev"
    sha256 cellar: :any, arm64_golden_gate: "9e2645e37bfa5e60139fc6039b71b9571365c755b4c5a2d4333b1eac75c34724"
    sha256 cellar: :any, arm64_tahoe:       "3997bcb14ad184cd771e1b41e50ebcaf58f7cc161b69c09d728ed3b2398c3cbf"
    sha256 cellar: :any, arm64_sequoia:     "5e060b59364681979bebe70fa9ecebe4f21b6238e1a009269a1707a6e707b81f"
    sha256 cellar: :any, arm64_linux:       "75cdd98943a7fd65218c7b8c7a3cec7e5ce6a4572098fecb8fc279f861a9bcea"
    sha256 cellar: :any, x86_64_linux:      "b9191c165c15cec8b2500cd74c95af66b19d2e8bc9c5c63764b804f2bd85d3ef"
  end

  depends_on "crystal" => :build
  depends_on "bdw-gc"
  depends_on "libevent"
  depends_on "libxml2"
  depends_on "openssl@4"
  depends_on "pcre2"
  depends_on "zlib-ng-compat"

  conflicts_with "mint", because: "both install `mint` binaries"

  def install
    system "shards", "install", "--ignore-crystal-version"
    system "crystal", "build", "src/mint.cr", "-o", "mint", "-p", "--release", "--no-debug"
    bin.install "mint"
  end

  test do
    system "#{bin}/mint", "init", "test-app"
    assert_path_exists testpath/"test-app/source/Main.mint"
    (testpath/"test-app").cd do
      port = free_port
      pid = fork do
        system "#{bin}/mint", "start", "--port=#{port}"
      end
      sleep 3

      begin
        assert_match "This application requires JavaScript", shell_output("curl -s http://localhost:#{port}/")
      ensure
        Process.kill "TERM", pid
        Process.wait pid
      end
    end
  end
end
