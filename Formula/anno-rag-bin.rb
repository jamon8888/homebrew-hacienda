class AnnoRagBin < Formula
  desc "anno-rag CLI binary — splits out so anno-rag-mcp can depend on anno-rag without a cycle."
  homepage "https://docs.rs/anno"
  version "0.13.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jamon8888/anno/releases/download/v0.13.5/anno-rag-bin-aarch64-apple-darwin.tar.xz"
      sha256 "ddf2ab26e527fa5edf7ac8021294e7ee872300983b298b7055ccb99502bac454"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jamon8888/anno/releases/download/v0.13.5/anno-rag-bin-x86_64-apple-darwin.tar.xz"
      sha256 "c303f6082fa60a105eff9dbde7b27dc85f02cde71cb6c00f146a7f993d4df277"
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
    bin.install "anno-rag" if OS.mac? && Hardware::CPU.arm?
    bin.install "anno-rag" if OS.mac? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
