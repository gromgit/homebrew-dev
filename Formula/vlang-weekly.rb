class VlangWeekly < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/weekly.2022.36.tar.gz"
  sha256 "e0ca06d7d0feaafaafe197cfbfac0922ecd005cde703b76e33ac01a08abeaf51"
  license "MIT"

  livecheck do
    url :stable
    regex(/^weekly\.(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/vlang-weekly-2022.36"
    sha256 cellar: :any_skip_relocation, monterey: "74ca42f12a7746b521fdd3f4f04618dda0a653ec82d3590033b5c116c6f0e664"
    sha256 cellar: :any_skip_relocation, big_sur:  "3123a38e97c055f8edfbd7d714ff6b0a8d6d9d002fd3e492ceb80c9f41a12c51"
    sha256 cellar: :any_skip_relocation, catalina: "a9c66d9993131fd33c078c0cafef3ade9e127cba149d789cf62624db50ab97a7"
    sha256 cellar: :any_skip_relocation, mojave:   "ff1d9ab36c9cc2e8881debb4d8dcff8f3af900049ed8d43fc82de74a9fab68b9"
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
