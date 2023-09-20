class Verible < Formula
  version '0.0-3416-g470e0b95'
  desc 'Verible is a suite of SystemVerilog developer tools, including a parser, style-linter, formatter and language server'
  homepage 'https://chipsalliance.github.io/verible/'
  head 'https://github.com/chipsalliance/verible.git'

  if OS.mac?
    Binary = "verible-v#{version}-macOS.tar.gz"
    sha256 "dc76f982cb7236d6937622272b59a0848f7287e2191b8aa8c6254cb30bb86438"
  elsif OS.linux?
    if Hardware::CPU.intel?
        Binary = "verible-v#{version}-linux-static-x86_64.tar.gz"
        sha256 "85a261faede891f5c038d350d45fb92ddd1db2d662f7dbbbad7aae719c226db9"
    else
        Binary = "verible-v#{version}-linux-static-aarch64.tar.gz"
        sha256 "57201b0b4e39549261f1535ec0d7a517cf3e2ce2e0690398dd5994648ebc334f"
    end
  end

  url "https://github.com/chipsalliance/verible/releases/download/v#{version}/#{Binary}"

  def install
    bin.install %w[
      bin/verible-verilog-diff
      bin/verible-verilog-format
      bin/verible-verilog-kythe-extractor
      bin/verible-verilog-lint
      bin/verible-verilog-ls
      bin/verible-verilog-obfuscate
      bin/verible-verilog-preprocessor
      bin/verible-verilog-project
      bin/verible-verilog-syntax
    ]
  end

  test do
    (testpath/"test.sv").write <<~EOS
      module    m   ;endmodule
    EOS
    (testpath/"test_formatted.sv").write <<~EOS
      module m;
      endmodule
    EOS
    output = shell_output("#{bin}/verible-verilog-format test.sv")
    assert_equal File.read(testpath/"test_formatted.sv"), output
  end
end

