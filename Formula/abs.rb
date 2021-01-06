class Abs < Formula
  desc "Shell scripting with a more modern syntax"
  homepage "https://www.abs-lang.org"
  url "https://github.com/abs-lang/abs/archive/2.4.0.tar.gz"
  sha256 "ea6fcb1cddfea4da960c01ebdba1e2b2cdb22975c86d956a68f64db17d48b0a8"
  license "MIT"
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/abs-2.4.0"
    cellar :any_skip_relocation
    sha256 "d017660bf39d1accd3acbfc5586969338bdc1931b626aaa079d722071624dbb0" => :catalina
    sha256 "1a3c05f2233556f9ef1e89943c92367f28c34946b9b248a7ebaccb3bf2f1bb78" => :x86_64_linux
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
