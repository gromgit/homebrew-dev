class VlangWeekly < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/weekly.2022.21.tar.gz"
  sha256 "e9ab20d192faaf1b9cea6c6b16a2b3b9885c8810a6ff47b82c8e59371383da84"
  license "MIT"

  livecheck do
    url :stable
    regex(/^weekly\.(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/vlang-weekly-2022.21"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0cbf4d7d452a000cfe153581aaa8c8d12908c2456a84d54322f05066c05bf45"
    sha256 cellar: :any_skip_relocation, big_sur:        "60b8caaad6bac868f007cecdfdfa588c7d14c959c692196c67af3be7d6f167dd"
    sha256 cellar: :any_skip_relocation, catalina:       "4e3e53c432b5536d1a518819a50e1cb29535aefafcd203cba3cf5994fac7b9f2"
    sha256 cellar: :any_skip_relocation, mojave:         "9c97e2f2f6b16ace21c95b6f5a51e1090bc2799fb1cf23cda2658d8edc4be359"
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
