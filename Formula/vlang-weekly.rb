class VlangWeekly < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/weekly.2022.39.tar.gz"
  sha256 "e626d9111c76e1f5c0a53b750154313ae062f02ea45b90fab1f5ef885bd3c837"
  license "MIT"

  livecheck do
    url :stable
    regex(/^weekly\.(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/vlang-weekly-2022.39"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "627faee5f3e61da9b984575e90231a7103d81b0bc692a6f6362b82d6a800bc53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "278926e8938fa42d3c2f4e67683bd7baf304316846e23e25ac1805751b873c58"
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
