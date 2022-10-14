class Umka < Formula
  desc "Statically-typed embeddable scripting language"
  homepage "https://github.com/vtereshkov/umka-lang"
  url "https://github.com/vtereshkov/umka-lang/archive/v0.8.tar.gz"
  sha256 "7c793835645ff33fe165e914ae44df633e75f3101a7b7923744bd4307cb47629"
  license "BSD-2-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/umka-0.8"
    sha256 cellar: :any, arm64_monterey: "e8816579c40a29b3b1ab1a8dc57734f54c67b78a3ea538aed88ffce02304789d"
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
