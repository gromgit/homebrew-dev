class VlangWeekly < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/weekly.2021.28.tar.gz"
  sha256 "a6a28e5a7984439d20e8cc31a01984ced065da9d7bd9ccc1a171f94ca2a06c68"
  license "MIT"

  livecheck do
    url :stable
    regex(/^weekly\.(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/vlang-weekly-2021.28"
    sha256 cellar: :any_skip_relocation, big_sur:      "dada312c39b757af6e6f481a36149792fe831b11048b78c2b5e6ac4288b1d9a8"
    sha256 cellar: :any_skip_relocation, catalina:     "1e61e5f24c525a708f9c08d1a36c0adcd0ac6d84530f99ec6e1484fe275395da"
    sha256 cellar: :any_skip_relocation, mojave:       "af64b2c22d83a3b08aab1664ac71f235a2603674791accb41d8e5c1ab02ad876"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ac1b0e7d1e4c7caff045f2eba7a4ad42d15294c99b2747b67c57f45e9d662a45"
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
