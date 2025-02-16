class Nsxiv < Formula
  desc "Neo Simple X Image Viewer"
  homepage "https://nsxiv.codeberg.page/"
  url "https://codeberg.org/nsxiv/nsxiv/archive/refs/tags/v33.tar.gz"
  sha256 "7562af026024c28a93f5ca0cefd170c6b139cf2974165bcd695932d2cd9345c5"
  license "GPL-2.0-or-later"
  head "https://codeberg.org/nsxiv/nsxiv.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/dev"
    sha256 cellar: :any,                 arm64_sonoma: "ae6660b5f46a073d861d7238949cd6e23d0997a165d81c8b316dedaf3a63d18a"
    sha256 cellar: :any,                 ventura:      "22e7b1d4c9cffa35a657559d77122e76e95745ada7a68326a48c9e3e72a3ebda"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "443f057eb16c87ed01a3b4c03138b076e08a30565e292ff32f5152488f24d9f7"
  end

  depends_on "giflib"
  depends_on "imlib2"
  depends_on "libexif"
  depends_on "libx11"
  depends_on "libxft"
  depends_on "webp"
  on_linux do
    depends_on "inotify-tools"
  end

  def install
    make_args = [
      "PREFIX=#{prefix}",
      "CPPFLAGS=-I#{Formula["freetype2"].opt_include}/freetype2",
      "LDLIBS=-lpthread",
    ]
    make_args << "HAVE_INOTIFY=0" if OS.mac?
    system "make", *make_args, "install"
  end

  test do
    assert_match "Error opening X display", shell_output("DISPLAY= #{bin}/nsxiv #{test_fixtures("test.png")} 2>&1", 1)
  end
end
