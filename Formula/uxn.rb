class Uxn < Formula
  desc "Tiny virtual machine and ecosystem"
  homepage "https://100r.co/site/uxn.html"
  url "https://git.sr.ht/~rabbits/uxn/archive/1.0.tar.gz"
  sha256 "29059ee288474e48fae4b9e755bbc8e1b392a9c7ac90449d7a6599385c145460"
  license "MIT"
  head "https://git.sr.ht/~rabbits/uxn", branch: "main"

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
