class VlangWeekly < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/weekly.2022.22.tar.gz"
  sha256 "c2e00738d6fee691babf2f123a629e07ea843d2b54551e9ea1f6a2e3bef57caf"
  license "MIT"

  livecheck do
    url :stable
    regex(/^weekly\.(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/vlang-weekly-2022.22"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "816b6bc8fbf11c488a730dfc0d22f3b9d439c00a1c8185cc6fa758dc062194a2"
    sha256 cellar: :any_skip_relocation, catalina:       "b2adfd5ce71900890eee3a07244fbdd8f13632e5d4061c8f6f58dd28fde05bc7"
    sha256 cellar: :any_skip_relocation, mojave:         "2edbb21dc2be0885eea5564370e435dc007a28956ce141a8a36ec094684e410a"
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
