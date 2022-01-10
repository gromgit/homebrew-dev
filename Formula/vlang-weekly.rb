class VlangWeekly < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/weekly.2022.02.tar.gz"
  sha256 "90888891558717cb221fb496964a89db3840856605defb7593ca2a9853896e18"
  license "MIT"

  livecheck do
    url :stable
    regex(/^weekly\.(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/vlang-weekly-2022.02"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71be112f5e93d1ed7391591790ffce0655ce8d6e6641f53340749c06347cd67c"
    sha256 cellar: :any_skip_relocation, monterey:       "b6f3012e45fafb6a0192d7ca3cf1bcfa67ec5f6eccab09525f0477adbfca464c"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae648ccbd11b47b813d0284d83c3e8a6388daa047859392a863a63673a90e452"
    sha256 cellar: :any_skip_relocation, catalina:       "8c89690e082786888b8c81af863b8670601f952508b80f489058fff454923c68"
    sha256 cellar: :any_skip_relocation, mojave:         "c4e7ec40d71b6f01933a192d89aa0c2b94ccd31fad965f55a7fa8656cc28f788"
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
