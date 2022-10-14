class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://github.com/Nuitka/Nuitka/archive/refs/tags/1.1.4.tar.gz"
  sha256 "619f93eff88e7ff3ecef6a13ef8224085bbc588b7a3cc0a4704d7807c29884c0"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/nuitka-1.1.4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1207ac0977ca645a7609c08d7692b39e6883ed3fde3d5c303ce6cb578720cda"
    sha256 cellar: :any_skip_relocation, monterey:       "79040604af2621b614e72cd73e5c5901a224f00772c64fd060b0810638b60ee2"
    sha256 cellar: :any_skip_relocation, big_sur:        "65b121fc873f3bb6fe4f9eabf517f1a0663b2add43d98370aca26544e4b08c1f"
    sha256 cellar: :any_skip_relocation, catalina:       "123271ffef1abde2db4d85b40d1c77d04e375d490b319ea5a74a18f9aca9ff6a"
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
