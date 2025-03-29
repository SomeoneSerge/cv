{ lib, newScope }:

lib.makeScope newScope (self: {
  TeX = self.callPackage (
    { texliveSmall }:
    texliveSmall.withPackages (
      ps: with ps; [
        academicons
        biber
        biblatex
        cm-unicode
        fontawesome5
        koma-moderncvclassic
        koma-script
        latexmk
        marvosym
        enumitem
      ]

    )
  ) { };
  cvFontsConf = self.callPackage (
    { makeFontsConf, TeX }:
    makeFontsConf {
      fontDirectories = [
        "${TeX}/share/texmf/"
      ];
    }
  ) { };
  cv = self.callPackage (
    {
      lib,
      stdenv,
      TeX,
      cvFontsConf,
    }:
    stdenv.mkDerivation {
      name = "cv.pdf";
      buildInputs = [ TeX ];
      src =
        let
          fs = lib.fileset;
        in
        fs.toSource {
          root = ./.;
          fileset = fs.unions [
            ./cv.tex
            ./.latexmkrc
            ./main.bib
            ./pic.jpg
          ];
        };
      FONTCONFIG_FILE = cvFontsConf;
      buildPhase = ''
        runHook preBuild
        (latexmk -xelatex cv.tex |& uniq) || (echo "[E] .log file:" ; uniq < cv.log >&2 ; exit 1)
        runHook postBuild
      '';
      installPhase = ''
        runHook preInstall
        install -m444 cv.pdf $out
        runHook postInstall
      '';
    }
  ) { };
  devShell = self.callPackage (
    {
      TeX,
      cvFontsConf,
      mkShellNoCC,
    }:
    mkShellNoCC {
      packages = [ TeX ];
      FONTCONFIG_FILE = cvFontsConf;
    }
  ) { };
})
