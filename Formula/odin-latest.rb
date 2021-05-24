class OdinLatest < Formula
  desc "Programming language with focus on simplicity, performance and modern systems"
  homepage "https://odin-lang.org/"
  url "https://github.com/odin-lang/Odin/archive/dev-2021-05.tar.gz"
  version "dev-2021-05"
  sha256 "0137e16a64d73859c5dc67615aa32c62a59b2671a12252b4274ff7aa528874ae"
  license "BSD-2-Clause"
  head "https://github.com/odin-lang/Odin.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+[a-z]?)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/odin-latest-dev-2021-05"
    sha256 cellar: :any, big_sur:  "0b4d3ea46922ccacf929199e15082526f7462a6009b53d38bd7e85e12f8a050d"
    sha256 cellar: :any, catalina: "7704cb194b107f54d5865eeb9142553fa65c352af34bd4a9a57e58539b210d5d"
    sha256 cellar: :any, mojave:   "f0723bcacd0b6563acc77023bc5390c9773371da221a907574c988bf6cfc7a52"
  end

  # Check if this can be switched to `llvm` at next release
  depends_on "llvm@11"

  uses_from_macos "libiconv"

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
