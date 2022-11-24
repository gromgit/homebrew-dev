class VlangWeekly < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/weekly.2022.47.tar.gz"
  sha256 "9b0bb6e18ef7e7511ac6b09083585bb1fd5d1405460c1402facdb76e0ec26823"
  license "MIT"

  livecheck do
    url :stable
    regex(/^weekly\.(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/vlang-weekly-2022.47"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32d76b1b1a60291dfd613ab9037b27a1d28d82cfd136beaad680d480b5619408"
    sha256 cellar: :any_skip_relocation, big_sur:        "fdf3a5e4f7041013dd8e01eb7072f91271585348158ec0c91b8de099d4222c0d"
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
