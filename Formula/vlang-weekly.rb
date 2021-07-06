class VlangWeekly < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/weekly.2021.27.tar.gz"
  sha256 "9c4811affbbd6c1d8aa080f69de4a6c13bb0b3d649b17fc0a6722c0d12230fe1"
  license "MIT"

  livecheck do
    url :stable
    regex(/^weekly\.(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/vlang-weekly-2021.27"
    sha256 cellar: :any_skip_relocation, big_sur:      "1b007b7f2c984ab49edb4826a7408f45dbd99524a3a5763febf885359edc4f29"
    sha256 cellar: :any_skip_relocation, catalina:     "f6622ccef817f727fde4c2ac241e7c04ec05b44c938b5688cd05735fb7e50aab"
    sha256 cellar: :any_skip_relocation, mojave:       "9ae07a416c46583bae9cedc10ad6be8cad7db09aa2975be2fe0043f7719642c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "fcf5c7f55967471b38c414e3cb8598ea5db930012307ea6910f737f83d225253"
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
