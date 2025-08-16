class MintLang < Formula
  desc "Programming language for single-page web applications"
  homepage "https://www.mint-lang.com/"
  url "https://github.com/mint-lang/mint/archive/refs/tags/0.27.0.tar.gz"
  sha256 "1960ea78acb5333f07e60beaaa3ea14ad2ac75640aaf11b61d245e814f53cb86"
  license "BSD-3-Clause"

  head "https://github.com/mint-lang/mint.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/dev"
    sha256 cellar: :any,                 arm64_sonoma: "fb577d3c3884b72ab36f7faf2d24e8f71757e493ab1e69390099fa94029844bf"
    sha256 cellar: :any,                 ventura:      "4e6e099ec89036d71fa7db8071d755075d43ac9ac157e108cddf04d14fe957df"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2ad78c4d7970590d74eb5c0e55338f1c32c2d90db48d980243a1d2a5bf1820dc"
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
