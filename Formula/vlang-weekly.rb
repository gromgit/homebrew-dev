class VlangWeekly < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/weekly.2021.52.tar.gz"
  sha256 "c4173ee1f168118c9361f82ec99d66d61c6e41769940447ceee6026af070f03d"
  license "MIT"

  livecheck do
    url :stable
    regex(/^weekly\.(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/vlang-weekly-2021.52"
    sha256 cellar: :any_skip_relocation, monterey: "5810ad0a1127f4415061330f091f00f84a12c97fc903f1474308d4da7e7d7b91"
    sha256 cellar: :any_skip_relocation, big_sur:  "0c413c98dc081611699d70e40023ebb0a02e6ef11d2f627024a4f2fc18f71a2f"
    sha256 cellar: :any_skip_relocation, catalina: "33d701970c3dfbbfa189ff389f9fec3adeab1ee2d2c428e274d9733d59fecc5a"
    sha256 cellar: :any_skip_relocation, mojave:   "f9f1d1e43426a4104cfe39106c72e34f27f4bbb278f24cbc3ca05d75ff15a198"
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
