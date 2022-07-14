class VlangWeekly < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/weekly.2022.28.tar.gz"
  sha256 "2df28ae061f4c04ac6775f5d3aec2e467fcc5db2af80c734e13460f7249efecb"
  license "MIT"

  livecheck do
    url :stable
    regex(/^weekly\.(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/vlang-weekly-2022.28"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e91ac02897e559000d27807114681daa201193010c2acea3ebbc657e5947f66"
    sha256 cellar: :any_skip_relocation, monterey:       "17284fa95c15bb17de8c7a4ce44481e378b6928a4609ba3526af8f0363ce16ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b5f4ee8e1f8c860941d3c6ce503ee768e2d248d1dadfc65c8925161cd75a48d"
    sha256 cellar: :any_skip_relocation, catalina:       "581c59ab71974c77a8eae000b800b879fd0bc7e91f4283b4380bb3faad7ef934"
    sha256 cellar: :any_skip_relocation, mojave:         "0d272f85d2990a3c2eebd08ff26cc0e01209b28af887f758405f7d3542032c1d"
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
