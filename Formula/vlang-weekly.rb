class VlangWeekly < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/weekly.2023.19.tar.gz"
  sha256 "5ffd9d3012301a62fd9d13699344c4bbd06811642074e2bcceaced668cf1eeab"
  license "MIT"

  livecheck do
    url :stable
    regex(/^weekly\.(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/vlang-weekly-2023.19"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01c4ff508d97636649af1ca93661c0a015201091d9ac66527c1f61da4fab2269"
    sha256 cellar: :any_skip_relocation, monterey:       "fb3f39f4adebe262ec4efbe48edccdaece7d2597890016947db794a010968b15"
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
