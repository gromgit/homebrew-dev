class MintLang < Formula
  desc "Programming language for single-page web applications"
  homepage "https://www.mint-lang.com/"
  url "https://github.com/mint-lang/mint/archive/refs/tags/0.28.1.tar.gz"
  sha256 "fe4bd9fb4aaf1cd7bac518bc7251ea65e68f27dd20d2db04124b8b9110179dd0"
  license "BSD-3-Clause"

  head "https://github.com/mint-lang/mint.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/dev"
    sha256 cellar: :any,                 arm64_tahoe:   "939c3bd6fdef3ee11da287dc78d68e414ad00a4625a1f25a9f8b5c20757f3c41"
    sha256 cellar: :any,                 arm64_sequoia: "eaa1173c04abda8a6815773c3a4338bd09beebbb9fece9130fd05ca7c7a6db72"
    sha256 cellar: :any,                 arm64_sonoma:  "0860080ef3aeaf7b3cc6a6f3d8b5a826006bb705900a8b997b580cb076dcfc80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82fcd8601ccadf7736d34cea1f32fc68859a99eb54681c3ab9a955b132df6fbd"
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
