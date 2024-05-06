{
  inputs = {
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    nixpkgs.url = "github:NixOs/nixpkgs/nixos-unstable";

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-filter = {
      url = "github:numtide/nix-filter";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      fenix,
      nix-filter,
      ...
    }@inputs:
    let
      cargoMeta = builtins.fromTOML (builtins.readFile ./Cargo.toml);
      packageName = cargoMeta.package.name;

      forSystems =
        function:
        nixpkgs.lib.genAttrs [ "x86_64-linux" ] (
          system:
          let
            pkgs = import nixpkgs {
              inherit system;

              overlays = [ (final: prev: { ${packageName} = self.packages.${system}.${packageName}; }) ];
            };

            fenix-pkgs = fenix.packages.${system};
            fenix-channel = fenix-pkgs.toolchainOf {
              channel = "nightly";
              date =
                builtins.replaceStrings [ "nightly-" ] [ "" ]
                  (builtins.fromTOML (builtins.readFile ./rust-toolchain.toml)).toolchain.channel;
              sha256 = "sha256-SzEeSoO54GiBQ2kfANPhWrt0EDRxqEvhIbTt2uJt/TQ=";
            };

            makeCrossPackage =
              packageName: pkgsCross:
              let
                pkgs = builtins.throw "defining cross pkg, accessing pkgs is a bug";
              in
              {
                "${packageName}-cross-${pkgsCross.stdenv.hostPlatform.config}${
                  if pkgsCross.stdenv.hostPlatform.isStatic then "-static" else ""
                }" =
                  let
                    toolchain =
                      with fenix-pkgs;
                      combine [
                        minimal.cargo
                        minimal.rustc
                        targets.${pkgsCross.rust.lib.toRustTarget pkgsCross.stdenv.targetPlatform}.latest.rust-std
                      ];
                  in
                  pkgsCross.callPackage (./. + "/nix/packages/${packageName}.nix") {
                    inherit cargoMeta;
                    flake-self = self;
                    nix-filter = import inputs.nix-filter;
                    rustPlatform = pkgsCross.makeRustPlatform {
                      cargo = toolchain;
                      rustc = toolchain;
                    };
                  };
              };
          in
          function {
            inherit
              system
              pkgs
              fenix-pkgs
              fenix-channel
              makeCrossPackage
              ;
          }
        );
    in
    {
      formatter = forSystems ({ pkgs, ... }: pkgs.alejandra);

      packages = forSystems (
        {
          pkgs,
          fenix-channel,
          system,
          makeCrossPackage,
          ...
        }:
        {
          ${packageName} = pkgs.callPackage (./. + "/nix/packages/${packageName}.nix") {
            inherit cargoMeta;
            flake-self = self;
            nix-filter = import inputs.nix-filter;
            rustPlatform = pkgs.makeRustPlatform {
              cargo = fenix-channel.toolchain;
              rustc = fenix-channel.toolchain;
            };
          };
          default = self.packages.${system}.${packageName};
        }
        // makeCrossPackage packageName pkgs.pkgsCross.musl64.pkgsStatic
        // makeCrossPackage packageName pkgs.pkgsCross.musl32.pkgsStatic
        // makeCrossPackage packageName pkgs.pkgsCross.aarch64-multiplatform-musl.pkgsStatic
        // makeCrossPackage packageName pkgs.pkgsCross.armv7l-hf-multiplatform.pkgsStatic
        // makeCrossPackage packageName pkgs.pkgsCross.mingwW64.pkgsStatic
      );

      devShells = forSystems (
        {
          pkgs,
          fenix-pkgs,
          fenix-channel,
          ...
        }:
        let
          fenixRustToolchain = fenix-channel.withComponents [
            "cargo"
            "clippy-preview"
            "rust-src"
            "rustc"
            "rustfmt-preview"
          ];
        in
        {
          default = pkgs.callPackage (./. + "/nix/dev-shells/${packageName}.nix") {
            inherit fenixRustToolchain cargoMeta;
          };
          ci = pkgs.callPackage (./nix/dev-shells/ci.nix) { inherit fenixRustToolchain cargoMeta; };
        }
      );
    };
}
