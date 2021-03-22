class Abs < Formula
  desc "Shell scripting with a more modern syntax"
  homepage "https://www.abs-lang.org"
  url "https://github.com/abs-lang/abs/archive/2.4.1.tar.gz"
  sha256 "f378e1ae9fda330bc3819587155f97fe7bed38fb39ba8847c94f6fa5b6f51745"
  license "MIT"
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/abs-2.4.1"
    sha256 cellar: :any_skip_relocation, catalina:     "add84050e632b1696000dc5304dbeef9a2e2e5b48d5a7d5232762194fb563575"
    sha256 cellar: :any_skip_relocation, mojave:       "4dc9fa5cda5f7c6d6a3f1fd21ba79c507898919b3f778297490bd846c5d1693f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "51a72624757858df2c5f652794a9e1b51ca8d635537e5fe1853f52289d87776a"
  end

  head do
    url "https://github.com/abs-lang/abs.git"
  end

  depends_on "go" => :build

  def install
    system "make", "build_simple"
    bin.install Dir["builds/*"]
    pkgshare.install "examples"
  end

  test do
    (testpath/"test.abs").write <<~EOS
      str = "Hello world!"

      echo(str[:5]) // Hello
      echo(str.split("")[:5]) // ["H", "e", "l", "l", "o"]
    EOS
    assert_match "Hello\n[\"H\", \"e\", \"l\", \"l\", \"o\"]", shell_output("#{bin}/abs test.abs")
  end
end
