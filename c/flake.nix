{
  description = "Aux template for C project";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      forAllSystems =
        function:
        nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (
          system: function nixpkgs.legacyPackages.${system}
        );
    in
    rec {
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell { inputsFrom = [ packages.${pkgs.system}.hello ]; };
      });

      packages = forAllSystems (pkgs: rec {
        default = hello;
        hello = pkgs.callPackage ./hello.nix { };
      });

      overlays.default = final: prev: { hello = prev.callPackage ./default.nix { }; };
    };
}
