class See < Formula
  desc "Mouse-friendly terminal viewer for PDFs, images, documents, animations and video"
  homepage "https://github.com/Youkin06/see"
  url "https://github.com/Youkin06/see/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "fd1e3073603fa7aa8342c1d4dbf1322f0e4aac33b5eb7c05758034eb0a740ab7"
  license "MIT"
  head "https://github.com/Youkin06/see.git", branch: "main"

  depends_on "python@3.15"

  def install
    # see's dependencies (pypdfium2, Pillow) ship prebuilt wheels with their own native
    # libraries, so install them with pip into a private virtualenv.
    python = formula_opt_libexec("python@3.15")/"bin/python"
    system python, "-m", "venv", libexec
    system libexec/"bin/pip", "install", "--no-cache-dir", "--quiet", buildpath
    bin.install_symlink libexec/"bin/see"
  end

  def caveats
    <<~EOS
      see needs a terminal with the kitty graphics protocol (Ghostty, kitty, WezTerm).
      To play videos, also install ffmpeg:
        brew install ffmpeg
    EOS
  end

  test do
    assert_match "see #{version}", shell_output("#{bin}/see --version")
    (testpath/"note.txt").write("hello")
    assert_match "must be run in a terminal", shell_output("#{bin}/see note.txt < /dev/null 2>&1", 1)
  end
end
