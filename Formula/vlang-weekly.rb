class VlangWeekly < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/weekly.2023.23.tar.gz"
  sha256 "bcd1d5d0eb7c398bfa8f1827835f56a6741237134cc09b3d0dc181e495a4c907"
  license "MIT"

  livecheck do
    url :stable
    regex(/^weekly\.(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/vlang-weekly-2023.23"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ab6b70ab6b1ed87099dc4467852bba6abecb29c8996def7d8c7c85edc4d9a75"
    sha256 cellar: :any_skip_relocation, monterey:       "c090ae3b7de9a4c88844f9949cdecb690fd6fb8268a1ec65e0c28a20e57f6315"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "998c70e586922f8e30b39b13d9fa1f554524dfb406b486c768ced25c0e78e801"
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
