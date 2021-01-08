class Kitty < Formula
  desc "Cross-platform, fast, feature full, GPU based terminal emulator"
  homepage "https://sw.kovidgoyal.net/kitty/"
  url "https://github.com/kovidgoyal/kitty/archive/v0.19.3.tar.gz"
  sha256 "28fc5de9b8934174801aa7d95c5a6f4c878a7e93eea15cdf06d9c982e1cd2fec"
  license "GPL-3.0-only"

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/kitty-0.19.3"
    cellar :any_skip_relocation
    sha256 "ed55f377cd2f74016a5a38d3f456e4798b4dc91110806cbf23bf8f6959b4bfe0" => :x86_64_linux
  end

  depends_on "ncurses" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "harfbuzz"
  depends_on "imagemagick"
  depends_on "libcanberra"
  depends_on "libpng"
  depends_on "libxcb"
  depends_on "libxcursor"
  depends_on "libxi"
  depends_on "libxinerama"
  depends_on "libxkbcommon"
  depends_on "libxrandr"
  depends_on :linux
  depends_on "mesa"
  depends_on "python-dbus"
  depends_on "python@3.9"
  depends_on "wayland-protocols"
  depends_on "zlib"

  def install
    system "make"
    system Formula["python@3.9"].opt_bin/"python3", "setup.py", "--prefix=#{prefix}",
      "--update-check-interval=0", "linux-package"
  end

  test do
    if ENV["DISPLAY"].nil?
      ohai "Can not test without a display."
      return true
    end
    (testpath/"test.py").write <<~'EOS'
      def on_close(boss, window, data):
        print("Homebrew is cool\n")
    EOS
    assert_match "Homebrew is cool", shell_output("#{bin}/kitty --watcher #{testpath}/test.py true")
  end
end
