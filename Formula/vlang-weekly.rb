class VlangWeekly < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/weekly.2021.46.tar.gz"
  sha256 "d5fda982ecb229d8c3b23d1e46a0927fef709427d5b818f273ea7c3fda1576c1"
  license "MIT"

  livecheck do
    url :stable
    regex(/^weekly\.(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/vlang-weekly-2021.46"
    sha256 cellar: :any_skip_relocation, monterey: "ed6a317c958f09dd2f4a9fdbc5b4e4ca21944554456ff26cd37cf051af9623ec"
    sha256 cellar: :any_skip_relocation, big_sur:  "441ebe14f3d5552426c95a1d3169ac9345962edb7d54ccf02260ad779719c78f"
    sha256 cellar: :any_skip_relocation, catalina: "b3a846dca17312a05bc0e1d42584a9519bbaf305dbb9475245e618bad5a182ff"
    sha256 cellar: :any_skip_relocation, mojave:   "d3d6520e4efa966eaaba9e4d35dccd5cc32d4e2c7ebbac74c621c1327e0ecfc9"
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
