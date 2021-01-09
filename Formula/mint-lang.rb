class MintLang < Formula
  desc "Programming language for single-page web applications"
  homepage "https://www.mint-lang.com/"
  url "https://github.com/mint-lang/mint/archive/0.11.0.tar.gz"
  sha256 "ced84713cb7b7c7d21a58a1b264b896a4319ce0b0b68d12cac9a8de4490bd485"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/mint-lang-0.11.0"
    cellar :any
    sha256 "44db3aa7ed8520391fec431fd314e57ef4c9c81a2bc40cd419a5c8e734139c21" => :catalina
    sha256 "dfd62cb445d1d57b21c9c22dfce49f78ed3dad23dec308742b839996b4bdf754" => :x86_64_linux
  end
  head do
    url "https://github.com/mint-lang/mint.git"
  end

  depends_on "crystal" => :build
  depends_on "libevent"
  depends_on "libxml2"
  depends_on "openssl@1.1"
  depends_on "pcre"
  depends_on "zlib"

  conflicts_with "mint", because: "both install `mint` binaries"

  def install
    system "shards", "install"
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
