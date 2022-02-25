class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://github.com/Nuitka/Nuitka/archive/refs/tags/0.6.19.7.tar.gz"
  sha256 "e7a0851bdcd5b4b9736ffe56e072707e0c5c86bd2f1b2b8d09e93ed168c3fa46"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/nuitka-0.6.19.7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "910b3368c358e49d56d3d14e0cb78fc13f2481cd8e0c816d9f7b7c1af4da36a9"
    sha256 cellar: :any_skip_relocation, monterey:       "a38d19c387678c921aff98558620a51967db4035c2e190a8cd9dc66bc32049a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "f193d0cad9774afbe71b0cfb67a657b0d8b5ba5cd761462867b556c210a160e0"
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
