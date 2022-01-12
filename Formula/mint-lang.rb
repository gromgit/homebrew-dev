class MintLang < Formula
  desc "Programming language for single-page web applications"
  homepage "https://www.mint-lang.com/"
  url "https://github.com/mint-lang/mint/archive/0.15.1.tar.gz"
  sha256 "e8dce6b3845944f4da1a6382fe79524bb89c59fcf961ab7af43e61ffd38f5f90"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/mint-lang-0.15.1"
    sha256 cellar: :any, arm64_monterey: "1dcd253c81d91961c8c883f106207b844f96c751e5f0d2311f5531f6586747ff"
    sha256 cellar: :any, monterey:       "1492b84fd9c4a29e870f2a451af8e23aaa04181dbe067738844bf18a85002e4b"
    sha256 cellar: :any, big_sur:        "8ebdf7165ff4924c3c49d305fe5864136068c9eec234dd49f76a7a7a61732eaa"
    sha256 cellar: :any, catalina:       "216cb541374d15874b236f0e502b0d8a160f38c4341ef28e85099a7ffd095dbf"
    sha256 cellar: :any, mojave:         "1f8579b32a7cb09ec53eb4675eb56d14f8c6f5526b5d9e11d721247c33aa63d4"
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
