class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://github.com/Nuitka/Nuitka/archive/refs/tags/0.7.3.tar.gz"
  sha256 "7e223dc1fa0f87c6f891fa7063b1746d1b8202422606750e49786ad2eae4f8b8"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/nuitka-0.7.3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "428ecf3e986b230949324c21befe61b041081954d8792b642c618d9f3cb69b94"
    sha256 cellar: :any_skip_relocation, monterey:       "a6905db6066b25463f3a0f87c708896cd91a4ca02a9177e5083480956fa00eb4"
  end

  depends_on "llvm"
  depends_on "python"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.py").write <<~EOS
      def talk(message):
          return "Talk " + message

      def main():
          print(talk("Hello World"))

      if __name__ == "__main__":
          main()
    EOS
    assert_match "Talk Hello World", shell_output("python test.py")
    system "#{bin}/nuitka3", "-o", "test", "test.py"
    assert_match "Talk Hello World", shell_output("./test")
    ohai "test = #{File.size("test")} bytes"
    ohai shell_output("/bin/ls -lR >&2")
  end
end
