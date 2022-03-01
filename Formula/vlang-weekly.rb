class VlangWeekly < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/weekly.2022.09.tar.gz"
  sha256 "3b2cc646552cea8af9ec5f35c5d10cd358b23b972e6b32d0b9ce79dcdd4c4a48"
  license "MIT"

  livecheck do
    url :stable
    regex(/^weekly\.(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/vlang-weekly-2022.09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b2bae90df46bade8bb00ee93e97cbeefe180db7cfd0cbdd281d3857dabff9ee"
    sha256 cellar: :any_skip_relocation, monterey:       "dc55b83037a4a90fe6213fbee4a91cd1f8e39b263830a35a7242936918c3606e"
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
