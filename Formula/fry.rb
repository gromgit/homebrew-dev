class Fry < Formula
  desc "FatScript interpreter"
  homepage "https://fatscript.org/en/"
  url "https://gitlab.com/fatscript/fry/-/archive/v4.2.0/fry-v4.2.0.tar.bz2"
  sha256 "35920264b939d8df7e57cf70cdd902b5ad0729c8363e2a6156847c3f9ebc06d3"
  license "GPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/dev"
    sha256 cellar: :any,                 arm64_sonoma: "fa18cb13c93b1f281211be6663a71107b9d642acd142d07b34a2cc479bf46171"
    sha256 cellar: :any,                 ventura:      "e2adc7d531d51c9ccc7d2265f942446da0c33f4503f0ce312c591d6ee501c9a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "41fd508796229b9983d0604ba20e0657e45db77abc3e98f14289e2c4b7302f1c"
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

