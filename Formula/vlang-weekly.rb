class VlangWeekly < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/weekly.2021.22.tar.gz"
  sha256 "e340c34bdbb8af47456832cc433d14f18da63798598cdf03d515517896d32d4e"
  license "MIT"

  livecheck do
    url :stable
    regex(/^weekly\.(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/vlang-weekly-2021.22"
    sha256 cellar: :any_skip_relocation, big_sur:  "9443a672d1e1b0d1590bcc5bac24299083f688cba86a7e405cbc296c5e284826"
    sha256 cellar: :any_skip_relocation, catalina: "a0c6b5c162b4b94424a0d6e482e403dffff8d9f07693abd7f406a4d607e70f8d"
    sha256 cellar: :any_skip_relocation, mojave:   "2afea6b4dd1d1242897473cd9a7960ecd7943377bb159c4b50daa748aec04bc4"
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
