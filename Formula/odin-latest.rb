class OdinLatest < Formula
  desc "Programming language with focus on simplicity, performance and modern systems"
  homepage "https://odin-lang.org/"
  url "https://github.com/odin-lang/Odin/archive/dev-2022-09.tar.gz"
  version "dev-2022-09"
  sha256 "74f23e45f1fd5a5785d6c75f0807aaaf36b10813bfbac7b5cc2920aa626742f7"
  license "BSD-2-Clause"
  head "https://github.com/odin-lang/Odin.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+[a-z]?)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/odin-latest-dev-2022-09"
    sha256 cellar: :any, arm64_monterey: "0d9dfb2f0bc416b51526b27219d47689d181a9199d924eebe90e1ebcfe896d83"
    sha256 cellar: :any, monterey:       "cf096258de4cf33c9485ffabd1a9221b2537bc6204357f200912aa3f021a3480"
  end

  # Check if this can be switched to `llvm` at next release
  depends_on "llvm"
  # Build failure on macOS 10.15 due to `__ulock_wait2` usage.
  # Issue ref: https://github.com/odin-lang/Odin/issues/1773
  depends_on macos: :big_sur

  fails_with gcc: "5" # LLVM is built with GCC

  def install
    # Keep version number consistent and reproducible for tagged releases.
    # Issue ref: https://github.com/odin-lang/Odin/issues/1772
    unless build.head?
      inreplace "build_odin.sh" do |s|
        s.gsub! "dev-$(date +\"%Y-%m\")", "dev-#{version}"
        s.gsub!(/^GIT_SHA=.*$/, "GIT_SHA=unknown")
      end
    end

    system "make", "release"
    libexec.install "odin", "core", "shared"
    (bin/"odin").write <<~EOS
      #!/bin/bash
      export PATH="#{Formula["llvm@11"].opt_bin}:$PATH"
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
    system "#{bin}/odin", "build", "hellope.odin", "-file", "-out:hellope"
    assert_equal "Hellope!\n", `./hellope`
  end
end
