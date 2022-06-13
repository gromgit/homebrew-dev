class VlangWeekly < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/weekly.2022.24.tar.gz"
  sha256 "cbc570f51cf7a40848699d0ef1768d5388f0465822a3aadfef2be8751d7bdb5f"
  license "MIT"

  livecheck do
    url :stable
    regex(/^weekly\.(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/vlang-weekly-2022.24"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8be0fbb28d361522b199a8b678e9ebee36a81452aa7af10e4315ac8d03a11d53"
    sha256 cellar: :any_skip_relocation, monterey:       "c8a3613c66fb2eec5193102d0fc950d59fcca4f3baacdfe3472332874d83dd9c"
    sha256 cellar: :any_skip_relocation, big_sur:        "6522a439a910ea35c3bedb7fee561852c93b53d623421a2bb5ab64601505afed"
    sha256 cellar: :any_skip_relocation, catalina:       "2675f1fab6375a8bd73b6ed79fd49e2d4e6ffdf46c4766ce8bcb24eb4077e83f"
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
