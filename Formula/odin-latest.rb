class OdinLatest < Formula
  desc "Programming language with focus on simplicity, performance and modern systems"
  homepage "https://odin-lang.org/"
  url "https://github.com/odin-lang/Odin/archive/dev-2021-12.tar.gz"
  version "dev-2021-12"
  sha256 "6f01ce561fd9e8d7a8c726876bcce22755d3e5339b522eebd6c6a0b26f336b6e"
  license "BSD-2-Clause"
  head "https://github.com/odin-lang/Odin.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+[a-z]?)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/odin-latest-dev-2021-12"
    sha256 cellar: :any, monterey: "0786dc0114421787858b92e0ee06e43da952f92c3ab55359135eec2f34cf9915"
    sha256 cellar: :any, big_sur:  "a8f79b4f8629ec4e823cc6fd8fa7f23781e48b5499f949df6f007b0a0ca076fc"
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
