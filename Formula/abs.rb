class Abs < Formula
  desc "Shell scripting with a more modern syntax"
  homepage "https://www.abs-lang.org"
  url "https://github.com/abs-lang/abs/archive/2.4.2.tar.gz"
  sha256 "bf950de75a14041cfb873a925ab4187ce0bae46a91d0982fa8563e40aa2e233d"
  license "MIT"
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/abs-2.4.2"
    sha256 cellar: :any_skip_relocation, big_sur: "c9ba37c5ec49baf2bdd524836fbddec92e6cf3c931e41ac8bfcaae9d4daf1a78"
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
