class Nuitka < Formula
  include Language::Python::Virtualenv

  desc "Python compiler written in Python"
  homepage "https://nuitka.net"
  url "https://github.com/Nuitka/Nuitka/archive/refs/tags/2.6.6.tar.gz"
  sha256 "dde904513d944b75ad06327a513e9f47a74914daa7a32d8470f99c6f7071a58e"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/dev"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "1c6d47e5f6d907695a9b74c0caba19a5bcd4be3da05057f635eba1d09a22c426"
    sha256 cellar: :any_skip_relocation, ventura:      "321f8eed0bb17b24785b08cb5776627f0d6c74e1a5ae75db2337943c7c195b86"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4aceb289207ce28a8202b80104fa0355e608379367893bbc4069ddcc4795f558"
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
