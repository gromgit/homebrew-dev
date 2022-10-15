class VlangWeekly < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/weekly.2022.41.tar.gz"
  sha256 "19e7e8f458d2de5a4499ba905ef3ca3dcbd937005286ebdeff6204ea1e071d33"
  license "MIT"

  livecheck do
    url :stable
    regex(/^weekly\.(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/vlang-weekly-2022.41"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b1cb58f2540a72f4dc56a6ce09faa79daf4734866ee0b64289865c318b4c3c4"
    sha256 cellar: :any_skip_relocation, monterey:       "624ce0cc15ab278b28e97ab50ae8dfa7eafd94ef9d12627f62f33f050feeed64"
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
