class VlangWeekly < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/weekly.2021.44.tar.gz"
  sha256 "f0045c70bfa516bb5de4f2ae9bd1d583a88685e5edc43107386439b2d91fb850"
  license "MIT"

  livecheck do
    url :stable
    regex(/^weekly\.(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/vlang-weekly-2021.44"
    sha256 cellar: :any_skip_relocation, big_sur:  "c4f1d1f8a9bfb0d81e790541d66719b960211cd9e423ecd09f57974ef8bd3824"
    sha256 cellar: :any_skip_relocation, catalina: "69ca0bf573c02a74e9db59fa379169b43635c84c4741f2903e287faf09add96f"
    sha256 cellar: :any_skip_relocation, mojave:   "0a46d5de1cbc0febdfc3d024130c76e7f4c475091adec9e255bfd45ccf0e89c0"
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
