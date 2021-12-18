class VlangWeekly < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/weekly.2021.50.3.tar.gz"
  sha256 "8ef3dcc917fb4425383b0fffaf499d428eeb0e6f6d3358c54164c7dc4de0c1aa"
  license "MIT"

  livecheck do
    url :stable
    regex(/^weekly\.(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/vlang-weekly-2021.50.3"
    sha256 cellar: :any_skip_relocation, monterey: "3f58569cacd6f024c85bf8cd6d4b6ae98fd95c349ad76485284f7cdfcdd37c9c"
    sha256 cellar: :any_skip_relocation, big_sur:  "b5b324e908152356c3f99ab7632063862a904a17496e3596e3747ed9ec669ccb"
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
