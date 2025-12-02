class MintLang < Formula
  desc "Programming language for single-page web applications"
  homepage "https://www.mint-lang.com/"
  url "https://github.com/mint-lang/mint/archive/refs/tags/0.28.0.tar.gz"
  sha256 "b76040b8ba448f1dd90c4407feb34af4d66a8049cbe00f9946981e369b7fc073"
  license "BSD-3-Clause"

  head "https://github.com/mint-lang/mint.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/dev"
    sha256 cellar: :any,                 arm64_tahoe:   "c12d107c4e6d2ac437ff33ab16d9b3769d339f1e76da943b692a073514248cc9"
    sha256 cellar: :any,                 arm64_sequoia: "ac783482bd2004909de48a6f674dfb62b7f9505e99c00d49ecfeb0044b278583"
    sha256 cellar: :any,                 arm64_sonoma:  "ff4b453b14bc61c48a4fbb69b3ccbfc047ab1708751de9d8198e0af00ae37918"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21af3807080d7d029dbf55aa9e5146e2e4fceeedd355758e04a125bdaebf13f9"
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
