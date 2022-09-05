class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://github.com/Nuitka/Nuitka/archive/refs/tags/1.0.6.tar.gz"
  sha256 "70a9a10799749a436c08f69eb7fd0e04a8dac80c4ff646177ae13cc3e1e5ac79"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/nuitka-1.0.6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7d63e84505cb7f6549711b2f100b3d1a16e5d30629923d0311bafa9b620aee8"
    sha256 cellar: :any_skip_relocation, monterey:       "77526e6ff211f799a6edce792217e369892e6275565af10539967b104d232be5"
  end

  depends_on "llvm"
  depends_on "python@3.9"

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
    assert_match "Talk Hello World", shell_output("python3 test.py")
    system "#{bin}/nuitka3", "-o", "test", "test.py"
    assert_match "Talk Hello World", shell_output("./test")
    ohai "test = #{File.size("test")} bytes"
    ohai shell_output("/bin/ls -lR >&2")
  end
end
