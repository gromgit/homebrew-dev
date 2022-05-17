class VlangWeekly < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/weekly.2022.20.tar.gz"
  sha256 "af398163c0490e5839b9f3ee904fc57a95412b98afa3fe15b3e652e08c8db566"
  license "MIT"

  livecheck do
    url :stable
    regex(/^weekly\.(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/vlang-weekly-2022.20"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "554cadf97baa35b9dfbe2bf76665c23af2dced8a2b4e8eca2bc8418123f93ffe"
    sha256 cellar: :any_skip_relocation, monterey:       "9f512591e9a36eca1e3e6ad43c2cbef9068879614eb434e15a1540d4b81e7206"
    sha256 cellar: :any_skip_relocation, big_sur:        "4ed91dbb8b5997717029ed4e8bcad9e9ec94b0fbe7efb1422c04344297ef84b6"
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
