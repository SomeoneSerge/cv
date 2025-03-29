{
  nixpkgs ? <nixpkgs>,
  pkgs ? import nixpkgs { },
}:

pkgs.callPackage ./packages.nix { }
