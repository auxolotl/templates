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
  };

  outputs =
    {
      self,
      nixpkgs,
      fenix,
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

            fenixPkgsFor = pkgs: fenix.packages.${pkgs.system};
            fenixChannelFor =
              pkgs:
              (fenixPkgsFor pkgs).toolchainOf {
                channel = "nightly";
                date =
                  builtins.replaceStrings [ "nightly-" ] [ "" ]
                    (builtins.fromTOML (builtins.readFile ./rust-toolchain.toml)).toolchain.channel;
                sha256 = "sha256-SzEeSoO54GiBQ2kfANPhWrt0EDRxqEvhIbTt2uJt/TQ=";
              };

            toolchainFor =
              pkgs:
              let
                fenix-pkgs = fenixPkgsFor pkgs;
              in
              with fenix-pkgs;
              combine [
                minimal.cargo
                minimal.rustc
                targets.${pkgs.rust.lib.toRustTarget pkgs.stdenv.targetPlatform}.latest.rust-std
              ];

            rustPlatformFor =
              pkgs:
              let
                toolchain = toolchainFor pkgs;
              in
              pkgs.makeRustPlatform {
                cargo = toolchain;
                rustc = toolchain;
              };

            crossPackageFor =
              pkgs:
              let
                rustPlatform = rustPlatformFor pkgs;
              in
              {
                "${packageName}-cross-${pkgs.stdenv.hostPlatform.config}${
                  if pkgs.stdenv.hostPlatform.isStatic then "-static" else ""
                }" = pkgs.callPackage (./. + "/nix/packages/${packageName}.nix") {
                  inherit cargoMeta rustPlatform;
                  flake-self = self;
                };
              };
          in
          function {
            inherit
              system
              pkgs
              fenixPkgsFor
              fenixChannelFor
              toolchainFor
              rustPlatformFor
              crossPackageFor
              ;
          }
        );
    in
    {
      formatter = forSystems ({ pkgs, ... }: pkgs.alejandra);

      packages = forSystems (
        {
          pkgs,
          fenixChannelFor,
          system,
          crossPackageFor,
          ...
        }:
        let
          fenix-channel = fenixChannelFor pkgs;
        in
        {
          ${packageName} = pkgs.callPackage (./. + "/nix/packages/${packageName}.nix") {
            inherit cargoMeta;
            flake-self = self;
            rustPlatform = pkgs.makeRustPlatform {
              cargo = fenix-channel.toolchain;
              rustc = fenix-channel.toolchain;
            };
          };
          default = self.packages.${system}.${packageName};
        }
        // crossPackageFor pkgs.pkgsCross.musl64.pkgsStatic
        // crossPackageFor pkgs.pkgsCross.musl32.pkgsStatic
        // crossPackageFor pkgs.pkgsCross.aarch64-multiplatform-musl.pkgsStatic
        // crossPackageFor pkgs.pkgsCross.armv7l-hf-multiplatform.pkgsStatic
        // crossPackageFor pkgs.pkgsCross.mingwW64.pkgsStatic
      );

      devShells = forSystems (
        { pkgs, fenixChannelFor, ... }:
        let
          fenix-channel = fenixChannelFor pkgs;
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
