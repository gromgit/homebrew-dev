class VlangWeekly < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/weekly.2022.11.tar.gz"
  sha256 "eba1cade5f88b399f7daf738a8df6fde64e0e12550a387e3279cfa5b07423179"
  license "MIT"

  livecheck do
    url :stable
    regex(/^weekly\.(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/vlang-weekly-2022.11"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4474171f03110aac222896e0a5411c4e626b6ffce1f989825d7db9cf18318cf1"
    sha256 cellar: :any_skip_relocation, monterey:       "d6fa311326534d290f5668abbbfb78189cc0c4229278605754535d8647e6782d"
    sha256 cellar: :any_skip_relocation, big_sur:        "f1831a7115e6e6bf7953ef7e3b1f3a82bfe3823175fa9b418232e5a220893211"
    sha256 cellar: :any_skip_relocation, catalina:       "855d12477bc64829960200af0217cc16b635c63e94850b709235eb7646cc4ee8"
    sha256 cellar: :any_skip_relocation, mojave:         "5ec0138918d37878b63f0124e9b4e12c4f5a8fc71ddbce16d74cf2cbed4014ed"
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
