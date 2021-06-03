class OdinLatest < Formula
  desc "Programming language with focus on simplicity, performance and modern systems"
  homepage "https://odin-lang.org/"
  url "https://github.com/odin-lang/Odin/archive/dev-2021-06.tar.gz"
  version "dev-2021-06"
  sha256 "e8562dcee230f2e8dd27462455c3cd4c798bad127d8c71fef9924b95a7d794bd"
  license "BSD-2-Clause"
  head "https://github.com/odin-lang/Odin.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+[a-z]?)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/odin-latest-dev-2021-06"
    sha256 cellar: :any, big_sur:  "fc16cc00cb9b14cc559ee2578651b8262c19822b58a0f4def26f52e91bdee555"
    sha256 cellar: :any, catalina: "2ca4585e10454a4de839c901a5b1ccca442239725f68314d68a2215484f8a717"
    sha256 cellar: :any, mojave:   "74b9e999554d583da34c3ed71ff351efbab856e07ec99ba6605b02870bb61024"
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
