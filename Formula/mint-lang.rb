class MintLang < Formula
  desc "Programming language for single-page web applications"
  homepage "https://www.mint-lang.com/"
  url "https://github.com/mint-lang/mint/archive/refs/tags/0.25.0.tar.gz"
  sha256 "64875fdcda223396d9c7d353654ad95f772c0b04e12a695b853366ea1014220d"
  license "BSD-3-Clause"

  head "https://github.com/mint-lang/mint.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/dev"
    sha256 cellar: :any,                 arm64_sonoma: "4772dd46c1837b82ff696b790ec48017ec966a1bc04ed338d89da767782956b4"
    sha256 cellar: :any,                 ventura:      "1f986996887d9e2031f3233fecb79b966ad88eacc7afd290f4262569e16381f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a3476cf8ae714ed1c1cb2891c8bfa3b824b51f81453e5e69623a854c2928c119"
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
