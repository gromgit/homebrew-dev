class VlangWeekly < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/weekly.2022.32.tar.gz"
  sha256 "c4f8b94710836a85aedce91879f2cbc2cbf14e9e0be035552c7990d4b2fede89"
  license "MIT"

  livecheck do
    url :stable
    regex(/^weekly\.(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/vlang-weekly-2022.32"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ca1b104039bc53d18c23c3d9163b0a2d8f69a28e9b36623656c8ef3c1d46446"
    sha256 cellar: :any_skip_relocation, monterey:       "243d8abfb5f43e86c7cfb081966a8952403d49eccd885f08a14e55ff3487368b"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b10d0f8858b9184eabd25c9c6dd308c3f55b032d4746740b110871248d5e524"
  end

  conflicts_with "vlang", because: "both install `v` binaries"

  def install
    system "make"
    libexec.install "cmd", "thirdparty", "v", "v.mod", "vlib"
    bin.install_symlink libexec/"v"
    pkgshare.install "examples", "tutorials"
    doc.install Dir["doc/*"]
  end

  test do
    cp pkgshare/"examples/hello_world.v", testpath
    system bin/"v", "-o", "test", "hello_world.v"
    assert_equal "Hello, World!", shell_output("./test").chomp
  end
end
