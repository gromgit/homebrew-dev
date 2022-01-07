class OdinLatest < Formula
  desc "Programming language with focus on simplicity, performance and modern systems"
  homepage "https://odin-lang.org/"
  url "https://github.com/odin-lang/Odin/archive/dev-2022-01.tar.gz"
  version "dev-2022-01"
  sha256 "44fcae303462f95b042423e93f08e096b14a55f2db1cfcf3d6b5a64f10621833"
  license "BSD-2-Clause"
  head "https://github.com/odin-lang/Odin.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+[a-z]?)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/odin-latest-dev-2022-01"
    sha256 cellar: :any, arm64_monterey: "54add6475d94f9589dd598bb6014c81380fcdd556a66916a8a5af789662bc6cf"
    sha256 cellar: :any, monterey:       "b48a624f85ee8192cc6cfa1c80eea30c4121bfe28127f3edee3d01ef8298d434"
    sha256 cellar: :any, big_sur:        "5f700f360880331a9ddb13cd962bb45c89f7f8145ba1e005f832e5713d0bb690"
    sha256 cellar: :any, catalina:       "f93ad8f0dc2e0d1b353706f4fdad24decf01baee0bbabcfe094cc423c937b250"
    sha256 cellar: :any, mojave:         "fd2b8d9c4c63a89592ae3a731c3fb2cb60fcd14537b2d820b7cfb68e68eb153e"
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
