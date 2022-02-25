class MintLang < Formula
  desc "Programming language for single-page web applications"
  homepage "https://www.mint-lang.com/"
  url "https://github.com/mint-lang/mint/archive/0.15.3.tar.gz"
  sha256 "8abe7c54547701e5639416a7dcf7930346041739a28437ae89f4ef2d4e2ea7e9"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/mint-lang-0.15.3"
    sha256 cellar: :any, arm64_monterey: "41a0c5eab7b29a99757cb4c76d7a3423461fb31ba66a4bac8b9822dd72e6b74e"
    sha256 cellar: :any, monterey:       "acb175d8c69023ac2ace38511c136ed8522d31e89d084856ef48137e0a5fc8e4"
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
