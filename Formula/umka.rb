class Umka < Formula
  desc "Statically-typed embeddable scripting language"
  homepage "https://github.com/vtereshkov/umka-lang"
  url "https://github.com/vtereshkov/umka-lang/archive/v0.7.tar.gz"
  sha256 "2ff79437862b38711273ca10d551b86219e71fce907844214f230d3f4a5e4b00"
  license "BSD-2-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/umka-0.7"
    sha256 cellar: :any,                 arm64_monterey: "b4ee0ec1e4f4a7c194702a5b658b9b89af86f75be30314f37888871ed88ea803"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b5db606f5319ce52b0b30385cf2b6727244431e4398ea0fd5dd377b451936f7"
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
