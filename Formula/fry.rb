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
    sha256 cellar: :any,                 arm64_tahoe:   "9754454cd4f4551fe8fbeb9c2db78e5ebc68c20a50be55b77775c72dc360b4af"
    sha256 cellar: :any,                 arm64_sequoia: "0cd5a75936115037b8c185bd9b94a65a0599ce6e6fb4ff90cf1d1ef8cfa5bed0"
    sha256 cellar: :any,                 arm64_sonoma:  "3603cceca2706b606320e7c474e936f6b585815bd780b5c14df9279abd5ac7bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29640ed12308660ab3c9b6b47bbf08a824472695159deb2e6acb5f618d74da65"
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
