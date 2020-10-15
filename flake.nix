{
  description = "Curriculum Vitae template";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
  flake-utils.lib.eachDefaultSystem (
    system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      stuff = import ./. { nixpkgs = pkgs; };
    in {
      packages.cv = stuff.cv;
      defaultPackage = self.packages.${system}.cv;
    }
    );
  }
