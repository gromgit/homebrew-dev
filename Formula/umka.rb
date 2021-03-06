class Umka < Formula
  desc "Statically-typed embeddable scripting language"
  homepage "https://github.com/vtereshkov/umka-lang"
  url "https://github.com/vtereshkov/umka-lang/archive/v0.5.1.tar.gz"
  sha256 "27795e8f51338907677cba6304893080ec0aaeb511401573376a73aef81892c5"
  license "BSD-2-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/umka-0.5.1"
    sha256 cellar: :any,                 big_sur:      "879cff40ab61b057faa81b46d9e0e1d4b9c44d0ea9bff79f40e7dbbee5893c5e"
    sha256 cellar: :any,                 catalina:     "fe1f4867cebfa9347374512aa905fd4382d9fda0452e06016e16fc2637281a6b"
    sha256 cellar: :any,                 mojave:       "1347537cb1aa3ee33eb431f6e0d5fb3a9b0123d3ded9db58d2dd7d1f46b0a7b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7dcc5d23be0391a925c38c5cf03d0dfca5e152d58c7437a2e8ce56011e349087"
  end
  head do
    url "https://github.com/gromgit/umka-lang.git"
  end

  def install
    system "make"
    bin.install "build/umka"
    lib.install Dir["build/libumka.*"]
    doc.install "examples"
  end

  test do
    (testpath/"test.um").write <<~EOS
      fn main() {
          printf("Hello Umka!\\n")
      }
    EOS
    assert_match "Hello Umka!", shell_output("#{bin}/umka test.um")
  end
end
