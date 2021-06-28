class VlangWeekly < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/weekly.2021.26.tar.gz"
  sha256 "5e7be69602aeb8027a8a46e7f67437add81c631ef9419fa1fbe1b401f794ffbd"
  license "MIT"

  livecheck do
    url :stable
    regex(/^weekly\.(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/vlang-weekly-2021.26"
    sha256 cellar: :any_skip_relocation, big_sur: "ff62b42e3ce27e16f79dcd9906361c235d0d4d393cb2a4f34b88a227d46e1e97"
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
