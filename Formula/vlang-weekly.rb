class VlangWeekly < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/weekly.2023.21.tar.gz"
  sha256 "5392afe42b307963a80fe2457810138bc7bbdc98df976d2267a74040e53c4a30"
  license "MIT"

  livecheck do
    url :stable
    regex(/^weekly\.(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/vlang-weekly-2023.21"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa4b61621f49bfb6537572106a0980712163b63fd36da89f7ed58ebb5fbb65df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ae65dae89bca9f6b97691971b62120a6248fb1befba78e9361569719f8ab3e7"
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
