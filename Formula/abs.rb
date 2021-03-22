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
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/abs-2.4.0"
    sha256 cellar: :any_skip_relocation, catalina:     "d017660bf39d1accd3acbfc5586969338bdc1931b626aaa079d722071624dbb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1a3c05f2233556f9ef1e89943c92367f28c34946b9b248a7ebaccb3bf2f1bb78"
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
