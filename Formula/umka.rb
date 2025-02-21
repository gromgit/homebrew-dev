class Umka < Formula
  desc "Statically-typed embeddable scripting language"
  homepage "https://github.com/vtereshkov/umka-lang"
  url "https://github.com/vtereshkov/umka-lang/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "9ea56cc32e1556989b81cd3db5d0ae533ac3af708ec5c742c36628d6310b52c4"
  license "BSD-2-Clause"

  head "https://github.com/gromgit/umka-lang.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/dev"
    sha256 cellar: :any,                 arm64_sonoma: "d76c66a17b96034c373216ce3a9daabe6882e7304d27b58359342884e76da6d9"
    sha256 cellar: :any,                 ventura:      "14e2a8a15a4247f1dbcf90f890e048e0cce1ac7e19e50ba1909ccf2800f7f339"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d3cd753a40e2a6087ae3a9069450a85cf9fcdf35df52644972aeb671556cf5b3"
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
