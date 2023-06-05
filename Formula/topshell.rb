require "language/node"

class Topshell < Formula
  desc "Purely functional, reactive scripting language"
  homepage "https://github.com/topshell-language/topshell"
  url "https://github.com/topshell-language/topshell/archive/v0.7.11.tar.gz"
  sha256 "9c0d4b9d6da9703cc93cf2d27db62af6841a98dcd3d586d118425dd40071ea9f"
  license "MIT"

  depends_on "node" => :build
  depends_on "sbt" => :build

  def install
    arch = if OS.linux?
      "linux-x64"
    else
      "macos-x64"
    end
    system "sbt", "clean", "fullOptJS"
    cd "node" do
      system "npm", "install", *Language::Node.local_npm_install_args
      system "node_modules/.bin/pkg", "-t", arch.to_s, "package.json"
      bin.install "topshell"
    end
  end

  test do
    pid = fork do
      exec "#{bin}/topshell"
    end
    sleep 1
    assert_match "200",
shell_output("curl -o /dev/null -s -w \%\{http_code\}\\n http://localhost:7070/topshell/index.html")
  ensure
    Process.kill "HUP", pid
    Process.wait pid
  end
end
