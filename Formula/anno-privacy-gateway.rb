class AnnoPrivacyGateway < Formula
  desc "Anthropic-compatible privacy gateway for Cowork and provider routing"
  homepage "https://docs.rs/anno"
  version "0.13.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jamon8888/anno/releases/download/v0.13.5/anno-privacy-gateway-aarch64-apple-darwin.tar.xz"
      sha256 "5bb87f9c9018e328ce63f254ddceb1e0846d18bc461fba322f746d753d4f781a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jamon8888/anno/releases/download/v0.13.5/anno-privacy-gateway-x86_64-apple-darwin.tar.xz"
      sha256 "952470e615923b77aa2f23ea3874eb5815b6190ea128b46e18cebb836005c227"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":  {},
    "x86_64-apple-darwin":   {},
    "x86_64-pc-windows-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "anno-privacy-gateway" if OS.mac? && Hardware::CPU.arm?
    bin.install "anno-privacy-gateway" if OS.mac? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
