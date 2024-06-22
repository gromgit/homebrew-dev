class MintLang < Formula
  desc "Programming language for single-page web applications"
  homepage "https://www.mint-lang.com/"
  url "https://github.com/mint-lang/mint/archive/refs/tags/0.17.0.tar.gz"
  sha256 "aff7b1aaa2a1ef1eeb4d4810c013fa29542b5c0040887880c5fd26e46d8812b9"
  license "BSD-3-Clause"

  head "https://github.com/mint-lang/mint.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/mint-lang-0.17.0"
    sha256 cellar: :any, arm64_monterey: "4ad06596901d25d31a9ab01cf6e8dcbc922834c73ad2edc5bac64187f10a146c"
    sha256 cellar: :any, big_sur:        "d33aa1c57c80bca92881cc8546c5660f93551eb51cac12d63e4ec57a406be864"
  end

  depends_on "crystal" => :build
  depends_on "libevent"
  depends_on "libxml2"
  depends_on "openssl@1.1"
  depends_on "pcre"
  depends_on "zlib"

  conflicts_with "mint", because: "both install `mint` binaries"

  def install
    system "shards", "install", "--ignore-crystal-version"
    system "crystal", "build", "src/mint.cr", "-o", "mint", "-p", "--release", "--no-debug"
    bin.install "mint"
  end

  test do
    system "#{bin}/mint", "init", "test-app"
    assert_predicate testpath/"test-app/source/Main.mint", :exist?
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
