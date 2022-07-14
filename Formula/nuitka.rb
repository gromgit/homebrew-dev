class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://github.com/Nuitka/Nuitka/archive/refs/tags/0.9.4.tar.gz"
  sha256 "7373ddae5d18fd84e148e280fa9265d83d18157d49ad5ec76a07af9185df7228"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/nuitka-0.9.4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf1f7abd2af0dbe4941862e873cbfd67125994904d7b8c67b71a74a8f27d7dea"
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
