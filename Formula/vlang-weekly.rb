class VlangWeekly < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/weekly.2022.38.tar.gz"
  sha256 "1f9b52e0a888d348470f38c5bb07757678cf83a54301d24ef32973537733f6b1"
  license "MIT"

  livecheck do
    url :stable
    regex(/^weekly\.(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/vlang-weekly-2022.38"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c543fd010fe8dc1ae28260e3af189fe997ac2dfb4727f2790a93d12a2ecd9764"
    sha256 cellar: :any_skip_relocation, big_sur:        "67ff703fccd1e3a667aca8ee11baa589647b57e8121d9dda7cda765b07716d36"
    sha256 cellar: :any_skip_relocation, catalina:       "8ebea29f50ccd07015597007b8d8a32f106e9c17d768117e9d7e2be9d73f44e3"
    sha256 cellar: :any_skip_relocation, mojave:         "1f86482865f58cf0ec109eabb397e8a0504a10f5e7adbc6ef0157b27940ffcac"
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
