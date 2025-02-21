class MintLang < Formula
  desc "Programming language for single-page web applications"
  homepage "https://www.mint-lang.com/"
  url "https://github.com/mint-lang/mint/archive/refs/tags/0.22.0.tar.gz"
  sha256 "7527f720b449d0336c785b7319d20d911a5fb588397f42b6252c8c813fe5deeb"
  license "BSD-3-Clause"

  head "https://github.com/mint-lang/mint.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/dev"
    sha256 cellar: :any,                 arm64_sonoma: "b1ebb8aaad33b6cc9e1297760b847752346a0a489105eeab8307644e49a80600"
    sha256 cellar: :any,                 ventura:      "71999c4bb88d0f8c83934b06235ea7a943bee84059d337d742ece0d2594f0868"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3900e47e220ab9bc5ace6f1220c7df3056d9b6f06b15935226816740041bb91f"
  end

  depends_on "crystal" => :build
  depends_on "bdw-gc"
  depends_on "libevent"
  depends_on "libxml2"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "zlib"

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
