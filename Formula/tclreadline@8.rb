class TclreadlineAT8 < Formula
  desc "GNU readline for interactive Homebrew Tcl8 shells"
  homepage "https://tclreadline.sourceforge.io"
  url "https://github.com/flightaware/tclreadline/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "d14b1568b6db8cd51659e3cc476a1f45da2020434ebb90b4b0defbc424f05907"
  license "BSD-3-Clause"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/dev"
    sha256 arm64_sonoma: "2a9f206bbfc9222829c5ebbfb289b8194a17aef11ba823c47b274007349391f5"
    sha256 ventura:      "1ef0f9b40acd744a037eb16d75669fadc4860834bb330bbaf6689e03df4b1f22"
    sha256 x86_64_linux: "fa4d7e17c0868f8744ac539ccfd651a893cf0383874928f402f5b2dc6a3d6266"
  end

  keg_only :versioned_formula

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "readline"
  depends_on "tcl-tk@8"

  # Version patch, review for removal in next release
  patch do
    url "https://github.com/flightaware/tclreadline/commit/0d793fc3ac647af977400b5673121bffcd57f6e3.patch?full_index=1"
    sha256 "1b65a1df3cd81f12b4da30952bac5c65576675ac3d2ca4a2cb9da9fd56c6f83e"
  end

  def tcltk
    Formula["tcl-tk@8"]
  end

  def install
    rl = Formula["readline"]
    autogen_args = %W[
      --disable-silent-rules
      --with-tcl=#{tcltk.opt_lib}
      --with-readline-includes=#{rl.include}
    ]
    system "autoreconf", "--force", "--install", "--verbose"
    system "./autogen.sh", *std_configure_args, *autogen_args
    system "make", "install"
    pkgshare.install "sample.tclshrc"
    (pkgshare/"basic.tclshrc").write <<~EOS
      if {$tcl_interactive} {
        set auto_path [linsert $auto_path 0 #{opt_lib}]
        package require tclreadline
        set tclreadline::historyLength 200
        tclreadline::Loop
      }
    EOS
  end

  def caveats
    <<~EOS
      See #{pkgshare} for example code to put in your ~/.tclshrc
      Your ~/.tclshrc must contain at least:
        set auto_path [linsert $auto_path 0 #{opt_lib}]
    EOS
  end

  test do
    (testpath/"test.tcl").write <<~TCL
      set auto_path [linsert $auto_path 0 #{opt_lib}]
      puts [package require tclreadline]
    TCL
    assert_equal shell_output("#{tcltk.bin}/tclsh test.tcl").strip, version.to_s
  end
end
