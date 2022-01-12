class Umka < Formula
  desc "Statically-typed embeddable scripting language"
  homepage "https://github.com/vtereshkov/umka-lang"
  url "https://github.com/vtereshkov/umka-lang/archive/v0.6.tar.gz"
  sha256 "81d7640f35c6a1c74a1553fb1af2ecf637fb7894c69919e95d66ce7a13d5e5a3"
  license "BSD-2-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/umka-0.6"
    sha256 cellar: :any, arm64_monterey: "70b550127dc14661e52597eb93c70d7662b6cf6ffd5bb2d1e161afc40fbedf0f"
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
