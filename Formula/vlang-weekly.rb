class VlangWeekly < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/weekly.2022.26.tar.gz"
  sha256 "9bea23ac4b0fa037833ba8e278e0e75ce1c16f4a2f38af0a59fab8e7aaf85b81"
  license "MIT"

  livecheck do
    url :stable
    regex(/^weekly\.(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/vlang-weekly-2022.26"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02dd7c5c66d8aa80dd2dc656a98db827f66b436bfcf5f46fa58408053692bf7d"
    sha256 cellar: :any_skip_relocation, monterey:       "f0e9f3b2ba8a79ecd8ad54e4e2318d29ffb18f953edefa3463f0038f6d34dcf9"
    sha256 cellar: :any_skip_relocation, big_sur:        "a2f8d80daf221074b446015717766f9cc86639b07296f93043b18732940a3043"
    sha256 cellar: :any_skip_relocation, catalina:       "1614c32401675a181b18d5231d3e2c6b92bd91efa478d7ece7429bb771e15ac3"
    sha256 cellar: :any_skip_relocation, mojave:         "754eb2a5f95156b622296fae2c42735290bac2fe4ed333bfb12bb0f937db3e87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fadbfb04516178ea56dac379d93775e6547023bcf058291fbb7e6b344b76a6b8"
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
