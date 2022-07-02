class OdinLatest < Formula
  desc "Programming language with focus on simplicity, performance and modern systems"
  homepage "https://odin-lang.org/"
  url "https://github.com/odin-lang/Odin/archive/dev-2022-07.tar.gz"
  version "dev-2022-07"
  sha256 "ff04664b5bc478e6a270e2ea08f162d54f585345793b8f63a1f8c625c6457671"
  license "BSD-2-Clause"
  head "https://github.com/odin-lang/Odin.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+[a-z]?)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/odin-latest-dev-2022-07"
    sha256 cellar: :any,                 arm64_monterey: "324122b6879bd6074425957af4046c31219e399a2db5b185b165f3824b6a29b4"
    sha256 cellar: :any,                 monterey:       "6646ffe02c3db0795ca6b2b4d0e3b864379aa48f8942d98d488d86bd0d6f78a7"
    sha256 cellar: :any,                 big_sur:        "a6394f9ee1f398330f017eba1c6155cb432180991d37e8fbdafc3530553dc051"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bef48a22769c577ca2f62f456e615d3334ed21c9344608aec29eec95738deba3"
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
