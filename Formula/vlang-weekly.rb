class VlangWeekly < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/weekly.2022.19.tar.gz"
  sha256 "a32c983f7d35b24fc84f76eeac75f33351c86ed3aed12b1d39c8c33b8b255e40"
  license "MIT"

  livecheck do
    url :stable
    regex(/^weekly\.(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/vlang-weekly-2022.19"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "366000c76c1ca6ced5d7fee94bc661a2dacbf70b852b99922e4d18cb6b8008b6"
    sha256 cellar: :any_skip_relocation, mojave:         "4ff92f25b825773bd3e35814e3c890d6d9982f1f8c6d7c556fc685b6f01a660c"
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
