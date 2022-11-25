class VlangWeekly < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/weekly.2022.47.tar.gz"
  sha256 "9b0bb6e18ef7e7511ac6b09083585bb1fd5d1405460c1402facdb76e0ec26823"
  license "MIT"

  livecheck do
    url :stable
    regex(/^weekly\.(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/vlang-weekly-2022.47"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32d76b1b1a60291dfd613ab9037b27a1d28d82cfd136beaad680d480b5619408"
    sha256 cellar: :any_skip_relocation, monterey:       "e93ef8dcd3296a87f72f7f9084e173ee8554d6e0623440d0e8805c86798bba1c"
    sha256 cellar: :any_skip_relocation, big_sur:        "fdf3a5e4f7041013dd8e01eb7072f91271585348158ec0c91b8de099d4222c0d"
    sha256 cellar: :any_skip_relocation, catalina:       "e25c7d3e1161e93ed8afc23d234ff7acc563dddfa40094837f3dd24ed866fad5"
    sha256 cellar: :any_skip_relocation, mojave:         "d4bb365e3200ce7b9ed44dbe211c20e4e7fae11e7ed9290a6d714ed644b2e104"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8d525ec035373d04007ce732a42ae8055ec5d217ff5e57b9ecd02df8c783090"
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
