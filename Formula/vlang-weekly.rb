class VlangWeekly < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/weekly.2022.12.tar.gz"
  sha256 "42ebf449a2ca4079e669c90b5d468b8753cef2453d9b101083ad33e50fb416da"
  license "MIT"

  livecheck do
    url :stable
    regex(/^weekly\.(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/vlang-weekly-2022.12"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85afd2d5607451dc24fda1b81bfba8553d874b769297afa616563ff9268b591d"
    sha256 cellar: :any_skip_relocation, monterey:       "57e243bc0dd010a4186418eba4e9ae2f796d76c455d89bc830542595c4cc8d05"
    sha256 cellar: :any_skip_relocation, big_sur:        "77403275a46b787dd613c3c3b213ec261369b96aa99c6865daeb2c5176506856"
    sha256 cellar: :any_skip_relocation, catalina:       "98cece786482678ec2450d082ecb2bd8fd58f1c0ae50c3e425d1957452b44e29"
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
