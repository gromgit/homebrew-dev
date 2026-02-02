class Fry < Formula
  desc "FatScript interpreter"
  homepage "https://fatscript.org/en/"
  # puil from git tag to get submodules
  url "https://gitlab.com/fatscript/fry.git",
    tag:      "v4.4.0",
    revision: "8ca37cec36950e2d027e2afdb7567804960d8fbc"
  license "GPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/dev"
    sha256 cellar: :any,                 arm64_sequoia: "6b2cc9257e9266bf31566d7c56442bdfe2ead7b373e88f237a255510fa926573"
    sha256 cellar: :any,                 arm64_sonoma:  "f1f6b80d0e488bbf14bdbe0ca363befa8ef48abafa5a95dedc9da6d8546ee157"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "138015d7c3a3a55511f43cfc93e33731abd93610a0f869b60797020ff99d083f"
  end

  depends_on "curl"
  depends_on "libffi"
  depends_on "openssl@3"

  def install
    ENV["CONT_IMG_VER"] = version
    ENV["useNCurses"] = "1"
    system "./compile.sh"
    bin.install "bin/fry"
    man1.install "man/fry.1"
    pkgshare.install "benchmark", "extras", "sample", "test"
  end

  test do
    assert_match "current time in Beijing", shell_output("#{bin}/fry #{pkgshare}/sample/timezones.fat")
  end
end
