{
  description = "Templates for getting started with Aux";

  inputs.nixpkgs.url = "github:auxolotl/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
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
    in rec {
      devShells.default = forAllSystems (pkgs:
        pkgs.mkShell {
          hardeningDisable = [ "fortify" ];
          inputsFrom = pkgs.lib.attrsets.attrValues packages;
        });

      packages = forAllSystems (pkgs: rec {
        default = hello;
        hello = pkgs.stdenv.mkDerivation rec {
          name = "hello";

          src = ./.;
          nativeBuildInputs = [ pkgs.gnumake ];

          enableParallelBuilding = true;
          V = 1;
          installPhase = ''
            install -D ${name} $out/bin/${name} --mode 0755
          '';
        };
      });

      apps = rec {
        default = hello;
        hello = builtins.mapAttrs
          (name: value: "${value.hello}/bin/hello") packages;
      };
    };
}
