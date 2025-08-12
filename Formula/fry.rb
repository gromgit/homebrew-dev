class Fry < Formula
  desc "FatScript interpreter"
  homepage "https://fatscript.org/en/"
  url "https://gitlab.com/fatscript/fry/-/archive/v4.2.1/fry-v4.2.1.tar.bz2"
  sha256 "c3ab9bf23206d4b54ae0c8f1603d5da62c81398f1bf065643ed54a885d28d407"
  license "GPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/dev"
    sha256 cellar: :any,                 arm64_sequoia: "df65973bb07a350c1e18d088d781f9ae9b127726d5cbab5f38a69cfe932f67c3"
    sha256 cellar: :any,                 arm64_sonoma:  "1dbf07287309bb3264d1bca095bd5136f29742c1de79372a221ffcacf1c3d60c"
    sha256 cellar: :any,                 ventura:       "5f4744fc80e268b6230677174296efeb56f8be2a124c592c99cfe3b9becfae77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9514e38130c1215ea834af0a06225fcc0928519044fd1e1542f034c11356ef8"
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

