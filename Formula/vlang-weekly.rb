class VlangWeekly < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/weekly.2023.22.tar.gz"
  sha256 "bb53a0e5ff0c754df8cda4fec37a302acde1e6f5459b071cf4a1c109bfbd0a8f"
  license "MIT"

  livecheck do
    url :stable
    regex(/^weekly\.(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/vlang-weekly-2023.22"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d33bc6d71d07a78612128477d6bfbd7cd3a189ea1eb5f33e01a8db5f9554359f"
    sha256 cellar: :any_skip_relocation, monterey:       "becd135d9520e870854b5cad19dc8563e2327ba2aad90278f55e2b63fa1b0531"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e09676479c59ac16585afbeba8ef09be51a62fbb2af0d39281043035f2be95ba"
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
