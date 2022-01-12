class Abs < Formula
  desc "Shell scripting with a more modern syntax"
  homepage "https://www.abs-lang.org"
  url "https://github.com/abs-lang/abs/archive/2.5.1.tar.gz"
  sha256 "a3d3fa8692e87a25d2aadfd38d684bd61ce83ca16916af3711f8b1a10dbee433"
  license "MIT"
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/abs-2.5.1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b0fea48ab080cc3baf6e9f9f1f21b4b0364eb16aada1b964dc0fd1a9d83b7a9"
    sha256 cellar: :any_skip_relocation, monterey:       "d0751bb2d730d5973c93a43a2b31ed1f63c4519c9d6e1a62863832825eaede7b"
    sha256 cellar: :any_skip_relocation, big_sur:        "d0235d755a6417f76bc936fe822509d109833fa138c0d95640823d44a17b923f"
    sha256 cellar: :any_skip_relocation, catalina:       "87964f8fbecb37f5d6bc6dec37c00e51dc413d21f3488a5c942940cfaa35caf3"
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
