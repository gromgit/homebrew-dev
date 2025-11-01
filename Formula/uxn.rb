class Uxn < Formula
  desc "Tiny virtual machine and ecosystem"
  homepage "https://100r.co/site/uxn.html"
  url "https://git.sr.ht/~rabbits/uxn/archive/1.0.tar.gz"
  sha256 "29059ee288474e48fae4b9e755bbc8e1b392a9c7ac90449d7a6599385c145460"
  license "MIT"
  head "https://git.sr.ht/~rabbits/uxn", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/dev"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89678a145fe0da203c1d5aa63d60afe32cb886d794582a5b160baab3a9feb898"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "715e6d419cacb0a19ac3a597b2262b79adf8d32d5e3021e2651b87408e133e08"
    sha256 cellar: :any_skip_relocation, ventura:       "13d3b543fdba4a494773137a737266f0dbd7e079c361d56b510706a85faccc0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a27b4b9e57c007661ff0855313ddbb52103bc53fa7f4d77c7addbf5e2555e34"
  end

  depends_on "sdl2"

  def install
    inreplace "build.sh", "$(brew --prefix)", HOMEBREW_PREFIX
    system "./build.sh", "--no-run"
    %w[uxnasm uxncli uxnemu].each do |f|
      bin.install "bin/#{f}"
    end
    pkgshare.install Dir["bin/*.rom", "projects/*"]
  end

  test do
    # Avoids "malloc: nano zone abandoned due to inability to reserve vm space"
    ENV["MallocNanoZone"] = "0" if OS.mac?

    system bin/"uxnasm", pkgshare/"examples/exercises/fizzbuzz.tal", testpath/"fizzbuzz.rom"
    assert_match "90 FizzBuzz", shell_output("#{bin}/uxncli #{testpath}/fizzbuzz.rom", 1)
  end
end
