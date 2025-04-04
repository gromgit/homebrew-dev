class GolangciLintAT1 < Formula
  desc "Fast linters runner for Go (v1)"
  homepage "https://golangci-lint.run/"
  url "https://github.com/golangci/golangci-lint.git",
        tag:      "v1.64.8",
        revision: "8b37f14162043f908949f1b363d061dc9ba713c0"
  license "GPL-3.0-only"
  head "https://github.com/golangci/golangci-lint.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/gromgit/dev"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "70d85d893e64b693b3ee4b461509e91d4e84211866a231eec1db6fea814e254e"
    sha256 cellar: :any_skip_relocation, ventura:      "54b58fbe727fe576740d9128c1e379f1011c7fc6623e9bda6ffeb91cd15093b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "557a0cb1699e672915d80c18ce3af644628debfbf5d48a845b626097aed76133"
  end

  keg_only :versioned_formula

  depends_on "go"

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_short_head(length: 7)}
      -X main.date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"golangci-lint"), "./cmd/golangci-lint"

    generate_completions_from_executable(bin/"golangci-lint", "completion")
  end

  def caveats
    <<~EOS
      This is the final v1 release. No further updates are expected.
    EOS
  end

  test do
    str_version = shell_output("#{bin}/golangci-lint --version")
    assert_match(/golangci-lint has version #{version} built with go(.*) from/, str_version)

    str_help = shell_output("#{bin}/golangci-lint --help")
    str_default = shell_output(bin/"golangci-lint")
    assert_equal str_default, str_help
    assert_match "Usage:", str_help
    assert_match "Available Commands:", str_help

    (testpath/"try.go").write <<~GO
      package try

      func add(nums ...int) (res int) {
        for _, n := range nums {
          res += n
        }
        clear(nums)
        return
      }
    GO

    args = %w[
      --color=never
      --disable-all
      --issues-exit-code=0
      --print-issued-lines=false
      --enable=unused
    ].join(" ")

    ok_test = shell_output("#{bin}/golangci-lint run #{args} #{testpath}/try.go")
    expected_message = "try.go:3:6: func `add` is unused (unused)"
    assert_match expected_message, ok_test
  end
end
