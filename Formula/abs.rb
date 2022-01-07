class Abs < Formula
  desc "Shell scripting with a more modern syntax"
  homepage "https://www.abs-lang.org"
  url "https://github.com/abs-lang/abs/archive/2.5.0.tar.gz"
  sha256 "a58d0aec2b4e702c226b1e095269923aef0db56622af95af308035b5047b3945"
  license "MIT"
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/abs-2.5.0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "afca21bdb4d8491b3ba1c01faf42c31ab45ade88a3b27104435ea554f4f59d7f"
    sha256 cellar: :any_skip_relocation, big_sur:        "d516cc2f5bb5bff047442943961a1d601b8cf446b6a677cc562793e982ecba05"
    sha256 cellar: :any_skip_relocation, catalina:       "ce91ac02c746bb11229c0081fbe1ea7a1d163bbd24d6c96fc16b2f2b51c9fe92"
    sha256 cellar: :any_skip_relocation, mojave:         "6a67e736e72dacf936377b1124068622be4f2f3adf00e908dfdd656944e78a12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f72361208cc6ef7a1112c480ea1a715b62dcb62a81eebd9e7da653765d40aea1"
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
