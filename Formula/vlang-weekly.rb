class VlangWeekly < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/weekly.2021.51.tar.gz"
  sha256 "21bd67e876dc5b4872f260fdd676e0c8bd0d423558f6970967d5be9d58583e03"
  license "MIT"

  livecheck do
    url :stable
    regex(/^weekly\.(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/vlang-weekly-2021.51"
    sha256 cellar: :any_skip_relocation, monterey: "c24f41763fe930690924c0726b585e720e2a929f8722798e7b6b9711b5bb012e"
    sha256 cellar: :any_skip_relocation, big_sur:  "088b85ff310efd0e61cfc5fc258a02fb490285fd4815eb8dd0ebe1d95b5ee91f"
    sha256 cellar: :any_skip_relocation, catalina: "99d73b370c0781efd7c823fe085e971ad096212e1cc28b6d22a7197770ac7126"
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
