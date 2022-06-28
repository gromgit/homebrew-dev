class Abs < Formula
  desc "Shell scripting with a more modern syntax"
  homepage "https://www.abs-lang.org"
  url "https://github.com/abs-lang/abs/archive/2.6.0.tar.gz"
  sha256 "b057a62d48ddfa14c29d735e57cb1b2a65b14cca3d2a5a2408569eb3e2f039a8"
  license "MIT"
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/abs-2.6.0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2e0981b10218d8ce0db4cff11aee1894eb3fa92f1702ec2b6470ecd224be51f"
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
