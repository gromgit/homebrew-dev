class OdinLatest < Formula
  desc "Programming language with focus on simplicity, performance and modern systems"
  homepage "https://odin-lang.org/"
  url "https://github.com/odin-lang/Odin/archive/dev-2021-07.tar.gz"
  version "dev-2021-07"
  sha256 "01f654983aa6895bd1e588ab60c0686717755c91df991d5689ad64f8f82063ec"
  license "BSD-2-Clause"
  head "https://github.com/odin-lang/Odin.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+[a-z]?)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/odin-latest-dev-2021-07"
    sha256 cellar: :any,                 big_sur:      "07b7a5e1cff0bbe2d6b0f3470c1fae983f07921040f3b915c7203f8f637d9e23"
    sha256 cellar: :any,                 catalina:     "232674b8e6051ccd451da73b8a7c4abd8a47be36240ff736f983eb1d531a55ac"
    sha256 cellar: :any,                 mojave:       "e93067d0ec923ddbf922214439529218262b51ab36c8985e8bed1262e74d9fb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "708e903373d3e1aa14651e3964d77e96e4ae17a43951d57a426b9b6287e9de81"
  end

  # Check if this can be switched to `llvm` at next release
  depends_on "llvm@11"

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
    system "#{bin}/odin", "build", "hellope.odin"
    assert_equal "Hellope!\n", `./hellope`
  end
end
