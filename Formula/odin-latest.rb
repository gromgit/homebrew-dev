class OdinLatest < Formula
  desc "Programming language with focus on simplicity, performance and modern systems"
  homepage "https://odin-lang.org/"
  url "https://github.com/odin-lang/Odin/archive/dev-2023-05.tar.gz"
  version "dev-2023-05"
  sha256 "4c4b2da50ae672f2a5c55335cf1752b3eb7ccc1a0c85f0d9651dbe1bbc5717f2"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/odin-lang/Odin.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+[a-z]?)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/odin-latest-dev-2023-05"
    sha256 cellar: :any, arm64_monterey: "85170e0d2a6bbd078d5be561e3b972e9a68e765a52da19cbcef010452991d861"
    sha256 cellar: :any, monterey:       "60d5b6ce9e456ab3aeb2a6cab349f8e0312f57e42ed9daf7d2cbd63f37b76100"
    sha256 cellar: :any, big_sur:        "95021910d5a2153e57a1246926b2e0c922b11cf9062b3f9e7472ea3e3affe9fb"
  end

  depends_on "llvm@14"
  # Build failure on macOS 10.15 due to `__ulock_wait2` usage.
  # Issue ref: https://github.com/odin-lang/Odin/issues/1773
  depends_on macos: :big_sur

  fails_with gcc: "5" # LLVM is built with GCC

  def install
    llvm = deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+(\.\d+)*)?$/) }

    # Keep version number consistent and reproducible for tagged releases.
    # Issue ref: https://github.com/odin-lang/Odin/issues/1772
    unless build.head?
      inreplace "build_odin.sh" do |s|
        s.gsub! "dev-$(date +\"%Y-%m\")", version.to_s
      end
    end

    system "make", "release"
    libexec.install "odin", "core", "shared"
    (bin/"odin").write <<~EOS
      #!/bin/bash
      export PATH="#{llvm.opt_bin}:$PATH"
      exec -a odin "#{libexec}/odin" "$@"
    EOS
    pkgshare.install "examples"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/odin version")

    (testpath/"hellope.odin").write <<~EOS
      package main

      import "core:fmt"

      main :: proc() {
        fmt.println("Hellope!");
      }
    EOS
    system "#{bin}/odin", "build", "hellope.odin", "-file"
    assert_equal "Hellope!\n", shell_output("./hellope.bin")
  end
end
