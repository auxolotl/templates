{
  description = "A simple system flake using some Aux defaults";

  inputs.nixpkgs.url = "github:auxolotl/nixpkgs/nixos-unstable";

  outputs =
    inputs@{ nixpkgs, ... }:
    let
      hostName = builtins.abort "You need to fill in your hostName"; # Set this variable equal to your hostName
    in
    {
      nixosConfigurations.${hostName} = nixpkgs.lib.nixosSystem {
        modules = [
          ./configuration.nix
          ./options.nix

          { aux.hostname = hostName; }
        ];

        specialArgs = {
          inherit inputs;
        };
      };
    };
}
