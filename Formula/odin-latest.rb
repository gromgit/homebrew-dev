class OdinLatest < Formula
  desc "Programming language with focus on simplicity, performance and modern systems"
  homepage "https://odin-lang.org/"
  url "https://github.com/odin-lang/Odin/archive/dev-2022-02.tar.gz"
  version "dev-2022-02"
  sha256 "d8d4ee55f34ce6634ae2037974bfd683b7432d990fc811df3b32ff5f36086dfc"
  license "BSD-2-Clause"
  head "https://github.com/odin-lang/Odin.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+[a-z]?)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/odin-latest-dev-2022-02"
    sha256 cellar: :any, arm64_monterey: "776f733cc7774beb5eb0d88041cb475360f0ca1f170e11ffbd191340ebd56b9f"
    sha256 cellar: :any, monterey:       "926c5e7f040807802ee0e9ef786b5edd9d881fb35e07e2c4867927e521c4a690"
    sha256 cellar: :any, mojave:         "b14648a51228c1f59f73a4a00ee3ede4c3dd24fa2a1b37893355b3179c64f47b"
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
