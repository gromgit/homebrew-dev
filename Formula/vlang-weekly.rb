class VlangWeekly < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/weekly.2022.43.tar.gz"
  sha256 "d22fa3026c3089dd4a41b3463e995765d62f3b884e1e8fa7455551cd6d750988"
  license "MIT"

  livecheck do
    url :stable
    regex(/^weekly\.(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/vlang-weekly-2022.43"
    sha256 cellar: :any_skip_relocation, catalina:     "32bb5623162f0daf79ae2e41830c21dae572c30eafd8ea115292e23ebae1d48c"
    sha256 cellar: :any_skip_relocation, mojave:       "84b53b903d39a347a0d082cc3ae414bba64a2b347d611612d95fb841c06af144"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e726fced10d8322f1445d920db8a01dfc43d9ff2758ba5dcbd7e74a3e8e1d3c6"
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
