class OdinLatest < Formula
  desc "Programming language with focus on simplicity, performance and modern systems"
  homepage "https://odin-lang.org/"
  url "https://github.com/odin-lang/Odin/archive/dev-2022-05.tar.gz"
  version "dev-2022-05"
  sha256 "44d178c74f8e5f1b0fbf6c3d2a3e85ec56a20f64bc17bbd46e1ea8da1e77479c"
  license "BSD-2-Clause"
  head "https://github.com/odin-lang/Odin.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+[a-z]?)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/odin-latest-dev-2022-05"
    sha256 cellar: :any, arm64_monterey: "1c0d2642928a4d1bfa9367949867a336bbe8d415b90790c9c16795a94a327d41"
  end

  # Check if this can be switched to `llvm` at next release
  depends_on "llvm"

  def install
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
