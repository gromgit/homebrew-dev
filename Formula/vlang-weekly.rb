class VlangWeekly < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/weekly.2021.45.tar.gz"
  sha256 "5b7af7d3d91f2afcb9af55dd7a4d185c944f52a88896d2eb108a7eae1489a3a0"
  license "MIT"

  livecheck do
    url :stable
    regex(/^weekly\.(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/vlang-weekly-2021.45"
    sha256 cellar: :any_skip_relocation, big_sur:  "41668c2646680a80b8f8c23465571fafa7192194835a758889507e5d4e1fd53c"
    sha256 cellar: :any_skip_relocation, catalina: "b7509c11589792a2a85f7f03019193728951ec6d7c99efef2c55d440364cafd6"
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
