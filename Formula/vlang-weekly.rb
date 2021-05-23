class VlangWeekly < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/weekly.2021.20.tar.gz"
  sha256 "4b71c74c044572aa183016e9e762228b714075d83231df504fcea68ded88226f"
  license "MIT"

  livecheck do
    url :stable
    regex(/^weekly\.(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/vlang-weekly-2021.20"
    sha256 cellar: :any_skip_relocation, mojave:       "61e0dcc0036642079d4019bde0972f7848d4b9e20b75a8fbc32212cd64456bce"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b4d653ceaf86c03d0f34e0566f3b968a982c9598d6398dc6ff88ff4f35978766"
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
