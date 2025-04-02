class MintLang < Formula
  desc "Programming language for single-page web applications"
  homepage "https://www.mint-lang.com/"
  url "https://github.com/mint-lang/mint/archive/refs/tags/0.23.2.tar.gz"
  sha256 "3b9c69b66c6e8ecf3e402c99104a6f8e890e77de65ad726eaf9fd8bc4637764d"
  license "BSD-3-Clause"

  head "https://github.com/mint-lang/mint.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/dev"
    sha256 cellar: :any,                 arm64_sonoma: "9f7d1c66dabe7b78ea81d112d732dc9bb6f34b45ef552d616899edf66ff97663"
    sha256 cellar: :any,                 ventura:      "a7be5d6e52d97c498cce1c11bf2ae1ab8b13c033d373957d8ab264e58c9547cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d374ea55a673e41caeadf19d0c1b216a61ca070de64d912cb53d46879fa228e0"
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
