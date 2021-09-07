final: prev:

with prev;

{
  myTexlive = with pkgs.texlive; (
    combine {
      inherit (pkgs.texlive)
      scheme-medium latexmk enumitem
      cm-unicode fontawesome
      biblatex biber
      moderncv moderntimeline;
    }
  );
  myFontsConf = pkgs.makeFontsConf {
    fontDirectories = [ 
      "${final.myTexlive}/share/texmf/"
    ];
  };
  cv = stdenv.mkDerivation {
    name = "cv.pdf";
    buildInputs = [ final.myTexlive ];
      src = ./.;
      FONTCONFIG_FILE = final.myFontsConf;
      buildPhase = ''
        latexmk -xelatex cv.tex || (cat cv.log >&2 && exit 1)
      '';
      installPhase = ''
        install -m444 cv.pdf $out
      '';
    };
}
