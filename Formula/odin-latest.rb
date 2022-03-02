class OdinLatest < Formula
  desc "Programming language with focus on simplicity, performance and modern systems"
  homepage "https://odin-lang.org/"
  url "https://github.com/odin-lang/Odin/archive/dev-2022-03.tar.gz"
  version "dev-2022-03"
  sha256 "6bf8f60978b6f8968aa723e1dd92a975c6ce3f811190369ba9019f37328f1852"
  license "BSD-2-Clause"
  head "https://github.com/odin-lang/Odin.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+[a-z]?)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/odin-latest-dev-2022-03"
    sha256 cellar: :any, arm64_monterey: "aa44667ee900b53e49d396163aac276639ff9f8f26c26a2c9f6703b085ed8376"
    sha256 cellar: :any, monterey:       "aa86d09e3a25f63500498da079579cc13f1ea0da68bb6fe62a99755f36d566d0"
    sha256 cellar: :any, big_sur:        "4e407598653b5251ec56d1bb2e6fe1bd90b26e0326ce9bd963dc34e9aeddfbd0"
    sha256 cellar: :any, mojave:         "853dd5d2f20c0461dec56e38dbbfc8231b9aed399e66ee2b6e27091ec214ad8d"
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
    system "#{bin}/odin", "build", "hellope.odin"
    assert_equal "Hellope!\n", `./hellope`
  end
end
