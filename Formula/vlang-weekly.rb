class VlangWeekly < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/weekly.2021.52.1.tar.gz"
  sha256 "50be78fe14c8a0e7ade60360d8681ca8e7c10e134148dda1810c62677c16be8b"
  license "MIT"

  livecheck do
    url :stable
    regex(/^weekly\.(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/vlang-weekly-2021.52.1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "846fb0fa02d2d5d79492c97d26ed99d9d58c3199916b01e2a05fe27c831f76ea"
    sha256 cellar: :any_skip_relocation, monterey:       "6cc882f18ca3770e1f1dba8baf4df402c30baf011b8afeaaf8632521037ae2b8"
    sha256 cellar: :any_skip_relocation, big_sur:        "587b9ba9ef8f073c2dc2f50e181bb4b402e89b16e04cd52e2c886aec9120f694"
    sha256 cellar: :any_skip_relocation, catalina:       "c891b460001766f64f13abd8f57c27d5080c72bcdb078cd574b1ec994c1dfa28"
    sha256 cellar: :any_skip_relocation, mojave:         "b62cbf39a7390f5c967786efb08e8d933b6285b17885f3c5bdf2c5701957c7d4"
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
