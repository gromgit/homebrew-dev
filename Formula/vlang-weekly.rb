class VlangWeekly < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/weekly.2021.30.tar.gz"
  sha256 "0bbaa8e4a6953e645f777fbc430fd197ca231f00b52b24e31ab41ac586eccd86"
  license "MIT"

  livecheck do
    url :stable
    regex(/^weekly\.(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/vlang-weekly-2021.30"
    sha256 cellar: :any_skip_relocation, big_sur:  "bb06555240ddad10bc6500e08103cc51475f79fe7a9c8a516ccce1fdc8427022"
    sha256 cellar: :any_skip_relocation, catalina: "f6c7385e922613be45ba526f379408659e390e7cd6e475013716c5ec44ed7b98"
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
