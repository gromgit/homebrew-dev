class Fry < Formula
  desc "FatScript interpreter"
  homepage "https://fatscript.org/en/"
  url "https://gitlab.com/fatscript/fry/-/archive/v4.3.0/fry-v4.3.0.tar.bz2"
  sha256 "51bcc8dd344d7b166c0c21a40e762fa4aa82fa549350743c0f55a4f1f454a9fa"
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
  depends_on "readline"

  patch :DATA

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

__END__
diff --git a/compile.sh b/compile.sh
index b9ae10e..ae32fb9 100755
--- a/compile.sh
+++ b/compile.sh
@@ -11,9 +11,9 @@
 # Licensed under the GNU General Public License v3.0.
 # See LICENSE file in the project root for full license.
 
-useNCurses=0   # set to 1 for ncurses, 0 for fatcurses
+useNCurses=${useNCurses:-0}   # set to 1 for ncurses, 0 for fatcurses
 
-if git version &>/dev/null
+if [ -d .git ] && git version &>/dev/null
 then
     FRY_VERSION="$(git describe --abbrev=6 --dirty --always --tags)"
 elif [ -z "$CONT_IMG_VER" ]

