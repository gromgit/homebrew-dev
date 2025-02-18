class VlangWeekly < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  url "https://github.com/vlang/v/archive/refs/tags/weekly.2025.08.tar.gz"
  sha256 "f2453e408f7d6b6b4dc22ce610a3114fa36dc43871a6b93ef433bd4fbe83f415"
  license "MIT"

  livecheck do
    url :stable
    regex(/^weekly\.(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/gromgit/dev"
    sha256                               arm64_sonoma: "27ba9e1255818cece50176d9cb9622334a947623cf1b8dd56afe595b8af14608"
    sha256 cellar: :any_skip_relocation, ventura:      "f75e4c5908146498875ed79de605b8e015a5c38271ac59b65c5a894b68477f3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b29cf1b8ecea2da72bdbcf0c040b7659c4bd48cc15c8aeec94bc6ac75b49a70c"
  end

  depends_on "bdw-gc" => :build
  on_linux do
    depends_on "libx11"
  end

  conflicts_with "vlang", because: "both install `v` binaries"

  # upstream discussion, https://github.com/vlang/v/issues/16776
  # macport patch commit, https://github.com/macports/macports-ports/commit/b3e0742a
  # patch :DATA

  def install
    # inreplace "vlib/builtin/builtin_d_gcboehm.c.v", "@PREFIX@", Formula["bdw-gc"].opt_prefix
    %w[up self].each do |cmd|
      (buildpath/"cmd/tools/v#{cmd}.v").delete
      (buildpath/"cmd/tools/v#{cmd}.v").write <<~EOS
        println('ERROR: `v #{cmd}` is disabled. Use `brew upgrade #{name}` to update V.')
      EOS
    end

    system "make"
    system "./v", "-prod", "-o", "v", "cmd/v"
    system "./v", "-prod", "build-tools"

    # clean up unnecessary stuff
    %w[thirdparty/tcc/.git].each { |d| rm_r(buildpath/d) }
    (buildpath/"cmd/tools/.disable_autorecompilation").write <<~EOS
      This is just a placeholder to tell V not to recompile any of its own tools.
    EOS

    libexec.install "cmd", "thirdparty", "v", "v.mod", "vlib"
    bin.install_symlink libexec/"v"
    pkgshare.install "examples", "tutorials"
    doc.install Dir["doc/*"]
  end

  test do
    cp pkgshare/"examples/hello_world.v", testpath
    system bin/"v", "-o", "test", "hello_world.v"
    assert_equal "Hello, World!", shell_output("./test").chomp
  end
end
#
# __END__
# diff --git a/vlib/builtin/builtin_d_gcboehm.c.v b/vlib/builtin/builtin_d_gcboehm.c.v
# index 2ace0b5..9f874c2 100644
# --- a/vlib/builtin/builtin_d_gcboehm.c.v
# +++ b/vlib/builtin/builtin_d_gcboehm.c.v
# @@ -37,13 +37,8 @@ $if dynamic_boehm ? {
#  } $else {
#  	$if macos || linux {
#  		#flag -DGC_BUILTIN_ATOMIC=1
# -		#flag -I @VEXEROOT/thirdparty/libgc/include
# -		$if (prod && !tinyc && !debug) || !(amd64 || arm64 || i386 || arm32) {
# -			// TODO: replace the architecture check with a `!$exists("@VEXEROOT/thirdparty/tcc/lib/libgc.a")` comptime call
# -			#flag @VEXEROOT/thirdparty/libgc/gc.o
# -		} $else {
# -			#flag @VEXEROOT/thirdparty/tcc/lib/libgc.a
# -		}
# +		#flag -I @PREFIX@/include
# +		#flag @PREFIX@/lib/libgc.a
#  		$if macos {
#  			#flag -DMPROTECT_VDB=1
#  		}
#
