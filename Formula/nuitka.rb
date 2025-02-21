class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://github.com/Nuitka/Nuitka/archive/refs/tags/2.6.6.tar.gz"
  sha256 "dde904513d944b75ad06327a513e9f47a74914daa7a32d8470f99c6f7071a58e"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/nuitka-1.1.4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1207ac0977ca645a7609c08d7692b39e6883ed3fde3d5c303ce6cb578720cda"
    sha256 cellar: :any_skip_relocation, monterey:       "79040604af2621b614e72cd73e5c5901a224f00772c64fd060b0810638b60ee2"
    sha256 cellar: :any_skip_relocation, big_sur:        "65b121fc873f3bb6fe4f9eabf517f1a0663b2add43d98370aca26544e4b08c1f"
    sha256 cellar: :any_skip_relocation, catalina:       "123271ffef1abde2db4d85b40d1c77d04e375d490b319ea5a74a18f9aca9ff6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fec6ff79dd6a11eaf169028cdad0931cdac458f72368a5aca2ea512d23ee607"
  end

  depends_on "ccache"
  depends_on "python@3.13"

  resource "ordered-set" do
    url "https://files.pythonhosted.org/packages/4c/ca/bfac8bc689799bcca4157e0e0ced07e70ce125193fc2e166d2e685b7e2fe/ordered-set-4.1.0.tar.gz"
    sha256 "694a8e44c87657c59292ede72891eb91d34131f6531463aab3009191c77364a8"
  end

  resource "zstandard" do
    url "https://files.pythonhosted.org/packages/ed/f6/2ac0287b442160a89d726b17a9184a4c615bb5237db763791a7fd16d9df1/zstandard-0.23.0.tar.gz"
    sha256 "b2d8c62d08e7255f68f7a740bae85b3c9b8e5466baa9cbf7f57f1cde0ac6bc09"
  end

  def install
    virtualenv_install_with_resources
    man1.install Dir["doc/*.1"]
    (share/"doc/#{name}").install Dir["*.rst"]
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
    system bin/"nuitka", "--onefile", "-o", "test", "test.py"
    assert_match "Talk Hello World", shell_output("./test")
    ohai "test = #{File.size("test")} bytes"
    ohai shell_output("/bin/ls -lR >&2")
  end
end
