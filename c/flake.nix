{
  description = "Aux template for C project";

  inputs.nixpkgs.url = "github:auxolotl/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      forAllSystems =
        function:
        nixpkgs.lib.genAttrs [
          "x86_64-linux"
          "aarch64-linux"
          "x86_64-darwin"
          "aarch64-darwin"
          "i686-linux"
          "mipsel-linux"
          "powerpc64le-linux"
        ] (system: function nixpkgs.legacyPackages.${system});
    in
    rec {
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          hardeningDisable = [ "fortify" ];
          inputsFrom = pkgs.lib.attrsets.attrValues packages;
        };
      });

      packages = forAllSystems (pkgs: rec {
        default = hello;
        hello = pkgs.callPackage ./default.nix { };
      });

      overlays.default = final: prev: { hello = final.callPackage ./default.nix { }; };

      apps = forAllSystems (pkgs: rec {
        default = hello;
        hello = {
          program = "${packages.${pkgs.system}.hello}/bin/hello";
          type = "app";
        };
      });
    };
}
