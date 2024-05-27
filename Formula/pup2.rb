class Pup2 < Formula
  desc "Parse HTML at the command-line (2nd generation)"
  homepage "https://github.com/gromgit/pup"
  url "https://github.com/gromgit/pup/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "939de10adb673381074e5210994b83e024905a232217380a162152aac534df67"
  license "MIT"
  head "https://github.com/gromgit/pup.git", branch: "master"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/pup2-0.4.1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a6d08531683f2a4a6d091b4a1cded0ece435346fe6ff6689f081e2d2fdd8cfac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df4ecec8938945ae5205129c1b0bd9854bee2c66afba64712df3e3254160146c"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    dir = buildpath/"src/github.com/gromgit/pup"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "."
      bin.install "pup" => "pup2"
    end

    prefix.install_metafiles dir
  end

  test do
    output = pipe_output("#{bin}/pup2 p text{}", "<body><p>Hello</p></body>", 0)
    assert_equal "Hello", output.chomp
  end
end
