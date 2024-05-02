{
  description = "A simple system flake using some Aux defaults";

  inputs.nixpkgs.url = "github:auxolotl/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      hostName = builtins.abort "You need to fill in your hostName"; # Set this variable equal to your hostName
      username = builtins.abort "You need to fill in your username"; # Set this variable equal to your username
    in
    {
      nixosConfigurations.${hostName} = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [ ./configuration.nix ];
        specialArgs = {
          inherit inputs;
        };
      };
    };
}
