class VlangWeekly < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/weekly.2022.16.tar.gz"
  sha256 "d6088e945a2d55f87263bf83ff422494d2f598f6c92f405a54307587a25befab"
  license "MIT"

  livecheck do
    url :stable
    regex(/^weekly\.(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/vlang-weekly-2022.16"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3163158e5ac88266b4d38824ffcf4bc110a3d674304dae2baacb5ccc8980e8d0"
    sha256 cellar: :any_skip_relocation, monterey:       "89fdf844339713877e253e9b589bb4fcbee108d64f915a84b9203359295933a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "f6a987793b99133ed4ec5dbcc23695fef832ca5723f5f04fbce8e632fca708f2"
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
