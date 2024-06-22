class Abs < Formula
  desc "Shell scripting with a more modern syntax"
  homepage "https://www.abs-lang.org"
  url "https://github.com/abs-lang/abs/archive/refs/tags/2.6.0.tar.gz"
  sha256 "b057a62d48ddfa14c29d735e57cb1b2a65b14cca3d2a5a2408569eb3e2f039a8"
  license "MIT"
  head "https://github.com/abs-lang/abs.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/abs-2.6.0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2e0981b10218d8ce0db4cff11aee1894eb3fa92f1702ec2b6470ecd224be51f"
    sha256 cellar: :any_skip_relocation, monterey:       "e29ce1e0a1cdf4eefbf2ab21dc3444aae61f6b598d71b1d6621e5e86a8bdcd3b"
    sha256 cellar: :any_skip_relocation, big_sur:        "9d425af534ab21dcdf0af7d57b56b9ced6f5714fb3fe9c49dfc9406efb4d192b"
    sha256 cellar: :any_skip_relocation, catalina:       "4c1aeb8ca05a66883aa25a337afe22ca3a291f46acee4aa18540c4fceb1dac42"
    sha256 cellar: :any_skip_relocation, mojave:         "68de36d2850b8854be7f2efa01f14846f950009327bcfad6879590c25f970572"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2907112d7800b6cb79a691831f29c81de6e7b51f41555fff644d816be8e10eaa"
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
