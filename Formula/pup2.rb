class Pup2 < Formula
  desc "Parse HTML at the command-line (2nd generation)"
  homepage "https://github.com/gromgit/pup"
  url "https://github.com/gromgit/pup/archive/v0.4.1.tar.gz"
  sha256 "939de10adb673381074e5210994b83e024905a232217380a162152aac534df67"
  license "MIT"
  head "https://github.com/gromgit/pup.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-dev/releases/download/pup2-0.4.1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b24361a5e6791862c52490140d002bf1d8eb3456038aa62264005ed1bd709b4"
  end

  depends_on "go" => :build
  depends_on "gox" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    dir = buildpath/"src/github.com/gromgit/pup"
    dir.install buildpath.children

    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s

    cd dir do
      system "gox", "-arch", arch, "-os", os, "./..."
      bin.install "pup_#{os}_#{arch}" => "pup2"
    end

    prefix.install_metafiles dir
  end

  test do
    output = pipe_output("#{bin}/pup2 p text{}", "<body><p>Hello</p></body>", 0)
    assert_equal "Hello", output.chomp
  end
end
