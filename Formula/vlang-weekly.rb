class VlangWeekly < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/weekly.2021.47.tar.gz"
  sha256 "d4cfcabda1206fceb532aad40a53219e1f20f8ea2223be569642146a7e00e6d2"
  license "MIT"

  livecheck do
    url :stable
    regex(/^weekly\.(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/vlang-weekly-2021.47"
    sha256 cellar: :any_skip_relocation, monterey: "326139efdb04f39babdcafc1d59c8841cc083a3e92828f50e6c02c2057b20073"
    sha256 cellar: :any_skip_relocation, big_sur:  "4f0a9eda9fe11b3a67b79fbd1d7599ec76fbc3e26c21a62151ebb88d3572e25f"
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
