class OdinLatest < Formula
  desc "Programming language with focus on simplicity, performance and modern systems"
  homepage "https://odin-lang.org/"
  url "https://github.com/odin-lang/Odin/archive/dev-2022-06.tar.gz"
  version "dev-2022-06"
  sha256 "6be176d1a69c9685be93ac0dcbf96da12c7896b890360cecc907700c9130ed45"
  license "BSD-2-Clause"
  head "https://github.com/odin-lang/Odin.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+[a-z]?)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/odin-latest-dev-2022-06"
    sha256 cellar: :any, arm64_monterey: "8d68eb324882150b6fc749992e10d757f7706124cfc7ffe5efbefa16dbad28e3"
    sha256 cellar: :any, monterey:       "7f4b6ae5a094825b0f59f82c17142dbeb5fd6ceb766b666fb2409ad0f5d39209"
  end

  # Check if this can be switched to `llvm` at next release
  depends_on "llvm"

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
