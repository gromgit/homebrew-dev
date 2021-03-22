class Umka < Formula
  desc "Statically-typed embeddable scripting language"
  homepage "https://github.com/vtereshkov/umka-lang"
  url "https://github.com/vtereshkov/umka-lang/archive/v0.4.1.tar.gz"
  sha256 "bd36c7f1b22abe86a04f4770f754ad178284cdbfcf79907dbbcace50ddaaa773"
  license "BSD-2-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/umka-0.4.1"
    sha256 cellar: :any, catalina:     "607e11b5b6a249496d730a64042077a308a79686c1966200590a07df11512dc9"
    sha256 cellar: :any, x86_64_linux: "e1035a61f94a40c3ce48d0179169f375be53fcb90258994f96b9c82c87c89571"
  end
  head do
    url "https://github.com/gromgit/umka-lang.git"
  end

  def install
    system "make"
    bin.install "umka"
    lib.install Dir["libumka.*"]
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
