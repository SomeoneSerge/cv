{
  description = "Curriculum Vitae template";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (
      system:
        let
          pkgs = import nixpkgs { inherit system; overlays = [ (import ./overlay.nix) ]; };
        in
          {
            packages.cv = pkgs.cv;
            defaultPackage = pkgs.cv;
            devShell = pkgs.mkShell {
              buildInputs = [ pkgs.myTexlive pkgs.texlab ];
              FONTCONFIG_FILE = pkgs.myFontsConf;
            };
          }
    );
}
