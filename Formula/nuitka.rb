class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://github.com/Nuitka/Nuitka/archive/refs/tags/0.6.19.1.tar.gz"
  sha256 "f21424695dc036add0b01e1b81efc2466070c5165e50f6c802a08f522b5b9126"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/nuitka-0.6.19.1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66d753b62eb863c2f9c27b27a6e7b70faf243cffdf7f9abdbab3731dc6b820bd"
    sha256 cellar: :any_skip_relocation, monterey:       "086df646730f768eff4f60047c79265dda5c770deb7fcef481f12ff554b65f49"
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
