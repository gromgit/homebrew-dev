class VlangWeekly < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/weekly.2021.25.tar.gz"
  sha256 "5833478b15062beea65550a5ff61aeafcda0706de9543888cce2e7b2554ceeeb"
  license "MIT"

  livecheck do
    url :stable
    regex(/^weekly\.(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/vlang-weekly-2021.25"
    sha256 cellar: :any_skip_relocation, big_sur:      "d3bb49df2a1aa20ff512f9bb7c0a32005561389324671323e1adc86e1fe29aa1"
    sha256 cellar: :any_skip_relocation, mojave:       "9ad87e0d97635e567f9d56063b5404f13963542a959703dbef1c4b649e185a3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "68ff2dabe10aa44cc32d5fa9cdaa0e10c4cdc9701b327ef18b2c60701bde1d45"
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
