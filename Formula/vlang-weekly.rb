class VlangWeekly < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/weekly.2022.10.tar.gz"
  sha256 "a408ea6dbeb50c66cf98e9f4bee225dcdde8c1ffddff1c4a7847bf8d22c49ae3"
  license "MIT"

  livecheck do
    url :stable
    regex(/^weekly\.(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/vlang-weekly-2022.10"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7f5f37c53db773c1fd1575afb35c6f6ed2dcf929521e06362f77681c1c3b642"
    sha256 cellar: :any_skip_relocation, big_sur:        "89f4a28735771f1a3642476457bc03523294cd97597adb18eb12e868dfad33b5"
    sha256 cellar: :any_skip_relocation, catalina:       "8204efd74cec3faa8547875d96b57ecb4ea29a96b3a1cf7e476d73cecd1d2feb"
    sha256 cellar: :any_skip_relocation, mojave:         "35104ec256203fdfaf415cdb50ce4176fdcd5fecbcd5731d175f41cb255e3a12"
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
