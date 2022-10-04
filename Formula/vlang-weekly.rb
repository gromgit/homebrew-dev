class VlangWeekly < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/weekly.2022.40.tar.gz"
  sha256 "458a85d770bbc9e62c91c346d4b3649b87b5db943c18fd2a1d694b8a21721eb6"
  license "MIT"

  livecheck do
    url :stable
    regex(/^weekly\.(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/vlang-weekly-2022.40"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d312a3ea42ecf5834849871ab286634068d86cd01d84afe14f24808cbf1d576"
    sha256 cellar: :any_skip_relocation, monterey:       "655cc0b83fa70354353b7850d6077f665bcaebd0d96e0cca3b94492eb9fc17af"
    sha256 cellar: :any_skip_relocation, big_sur:        "e722377a60b03063d28916b7a585ca2e9db868204b10ff8f9866ad89a7d4d3e4"
    sha256 cellar: :any_skip_relocation, catalina:       "e3dcf7b3c912a48cbc6ddfa7aab29c1568f0c4b388cc05609ded3e2ed6522cd5"
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
