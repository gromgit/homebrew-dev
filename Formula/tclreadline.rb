class Tclreadline < Formula
  desc "GNU readline for interactive Tcl shells"
  homepage "https://tclreadline.sourceforge.io"
  url "https://github.com/flightaware/tclreadline/archive/refs/tags/v2.4.1.tar.gz"
  sha256 "d14b1568b6db8cd51659e3cc476a1f45da2020434ebb90b4b0defbc424f05907"
  license "BSD-3-Clause"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/gromgit/dev"
    sha256 arm64_golden_gate: "7eaadcbcea5809a56d1846275e379062f56bc0f5218d7854d6d17f6aad9eced3"
    sha256 arm64_tahoe:       "5b89b8d332fb1954cd23203ba31f347647c1945975e775d33d22934ecd860333"
    sha256 arm64_sequoia:     "33aa1e28e45ca559514fc9e89ae3a029be47fbe98531798f84573d8ba2cad779"
    sha256 arm64_linux:       "57e9788e3fb851aa620e850718e74b0c6b8a67b580c3d34b54d6e88d286c1c14"
    sha256 x86_64_linux:      "9aba21de7b6e33e32654c5eeaa85c7a350fbb3f180cd38d31b6f4192936de00c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "readline"
  depends_on "tcl-tk"

  # Version patch, review for removal in next release
  patch do
    url "https://github.com/flightaware/tclreadline/commit/0d793fc3ac647af977400b5673121bffcd57f6e3.patch?full_index=1"
    sha256 "1b65a1df3cd81f12b4da30952bac5c65576675ac3d2ca4a2cb9da9fd56c6f83e"
  end

  def tcltk
    Formula["tcl-tk"]
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
