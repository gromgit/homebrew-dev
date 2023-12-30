class Nsxiv < Formula
  desc "Neo Simple X Image Viewer"
  homepage "https://nsxiv.codeberg.page/"
  url "https://codeberg.org/nsxiv/nsxiv/archive/v32.tar.gz"
  sha256 "49ef1eb775ef6c34f55dada7a3f446c9c5c6773c9e208509ffef27a656338a90"
  license "GPL-2.0-or-later"
  head "https://codeberg.org/nsxiv/nsxiv.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/nsxiv-30"
    rebuild 1
    sha256 cellar: :any_skip_relocation, x86_64_linux: "321b5a9310ab612a967af6c6c81fb1258bf665ec13ab0901cc555a2d49678cd5"
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
