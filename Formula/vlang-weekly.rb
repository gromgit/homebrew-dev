class VlangWeekly < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/weekly.2022.01.tar.gz"
  sha256 "fca618930f5edb24947571eff0af7f8143cd26103b7e25be30706e2a401fa90f"
  license "MIT"

  livecheck do
    url :stable
    regex(/^weekly\.(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/vlang-weekly-2022.01"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2efe705be3559440708c505babc34561f2830ddcb4aedab2ec1deaacd0cb734"
    sha256 cellar: :any_skip_relocation, monterey:       "1ff3f9d6297322558247d4e42ee85be4314754eca5068f7139df2d2de0aecfa3"
    sha256 cellar: :any_skip_relocation, big_sur:        "2dc09bdb1c52fa764bc2161983f6a7d9be59bec34217e9e5584417e517a030ee"
    sha256 cellar: :any_skip_relocation, catalina:       "c270864346208dca6813a41af2d8d3ee6e029a6aeb3d8a5b3e84812db8fb1967"
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
