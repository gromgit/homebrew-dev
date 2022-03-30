class VlangWeekly < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/weekly.2022.13.tar.gz"
  sha256 "5df66008b01de13d02da9f8f0ed47438e1ce01e82543738a33a7dcc65240aa37"
  license "MIT"

  livecheck do
    url :stable
    regex(/^weekly\.(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/vlang-weekly-2022.13"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72bf05434eba23a816aa03f96ed33146db8dea7105bbf4d1595d1124bdac5f1f"
    sha256 cellar: :any_skip_relocation, mojave:         "c68f1a4489b6fc0f3536bb1b2709466e6f815acca338e3a5531b8bcbc71ba6d0"
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
