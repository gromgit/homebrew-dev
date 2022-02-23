class VlangWeekly < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/weekly.2022.07.tar.gz"
  sha256 "a78dd68239ba615fd5b2763b18f6d7935f09f574a3c6539ccf9ab6a660a791c9"
  license "MIT"

  livecheck do
    url :stable
    regex(/^weekly\.(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/vlang-weekly-2022.07"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22bc1636e841fb671e173518872c47c24924a4473b63fb819b3d12d7fc74078d"
    sha256 cellar: :any_skip_relocation, monterey:       "d111071ec9960fbdfec1005c3efc5f79d64d4b94a1bdce61128582f990e64bac"
    sha256 cellar: :any_skip_relocation, big_sur:        "690b97c03444eb028d0c9b50ea6e62b8719d286fabdafbcc9cecfe6f39c7418e"
    sha256 cellar: :any_skip_relocation, mojave:         "156ccbfc4e7ce03b846343a271be99b65c6d33757b424270d4fd4f038616c9a6"
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
