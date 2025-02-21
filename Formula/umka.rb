class Umka < Formula
  desc "Statically-typed embeddable scripting language"
  homepage "https://github.com/vtereshkov/umka-lang"
  url "https://github.com/vtereshkov/umka-lang/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "9ea56cc32e1556989b81cd3db5d0ae533ac3af708ec5c742c36628d6310b52c4"
  license "BSD-2-Clause"

  head "https://github.com/gromgit/umka-lang.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/umka-0.8"
    sha256 cellar: :any,                 arm64_monterey: "e8816579c40a29b3b1ab1a8dc57734f54c67b78a3ea538aed88ffce02304789d"
    sha256 cellar: :any,                 monterey:       "18e53a1194ff4f60876837b7d00a95ffcb264fca99851a6818fde357f12fa12c"
    sha256 cellar: :any,                 big_sur:        "95a76e7f6c535b0058acc0795e03b32bf7eef515a79a667d624fb147a3df44e0"
    sha256 cellar: :any,                 catalina:       "bdfa0622a6a591fbb274f8dcd0e244632b5586a10c39c057d2a0f4a942723a51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fabf6bef6755984805bd3f9854835be30e28119c997c5e2060f59f93b20751ac"
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
