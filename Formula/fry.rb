class Fry < Formula
  desc "FatScript interpreter"
  homepage "https://fatscript.org/en/"
  # puil from git tag to get submodules
  url "https://gitlab.com/fatscript/fry.git",
    tag:      "v4.7.0",
    revision: "d705bff8a938c2491e87e4d31a6d0e05d55d514f"
  license "GPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/dev"
    sha256 cellar: :any, arm64_golden_gate: "61f665f82889604b85b5b583e8a8b06b212174b6db7fad063d86b33ac51a4c8c"
    sha256 cellar: :any, arm64_tahoe:       "c2574f418fde5d2e7e65801b87ddef206a5afc9e397b173570b30bef66ef4772"
    sha256 cellar: :any, arm64_sequoia:     "e9c3014840cc56d161b3149aa08efacc60ceb27d582e5f19bc355d7dec56b827"
    sha256 cellar: :any, arm64_linux:       "08beb7f1200b2eec469d5f238bf4e8f03384920c2e6dda76c903ef2128c16219"
    sha256 cellar: :any, x86_64_linux:      "df1183dd7daeae53f301dd4ad7ed079cafb4ca387d57fbd04ec0310a15e12cac"
  end

  depends_on "curl"
  depends_on "libffi"
  depends_on "openssl@4"

  def install
    ENV["CONT_IMG_VER"] = version
    ENV["useNCurses"] = "1"
    system "./compile.sh"
    bin.install "bin/fry"
    man1.install "man/fry.1"
    pkgshare.install "benchmark", "extras", "sample", "test"
  end

  test do
    assert_match "current time in Beijing", shell_output("#{bin}/fry #{pkgshare}/sample/timezones.fat")
  end
end
