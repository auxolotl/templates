{
  description = "A simple darwin flake using Aux and home-manager";

  inputs = {
    # nixpkgs is the input that we use for this flake the end section `nixpkgs-unstable` refers to the branch
    # of nixpkgs that we want to use. This can be changed to any branch or commit hash.
    nixpkgs.url = "github:auxolotl/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";

      # The `follows` keyword in inputs is used for inheritance.
      # we do this in order to prevent duplication of the nixpkgs input, and potential
      # issues with different versions of given packages.
      # However, it should be noted that this can lead to having to rebuild packages from source.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      darwin,
      home-manager,
      ...
    }:
    # we can use the `let` and `in` syntax to define variables
    # and use them in the rest of the expression
    let
      # this can be either aarch64-darwin or x86_64-darwin
      # if your using a M1 or later your going to need to use aarch64-darwin
      # otherwise you can use x86_64-darwin
      system = builtins.abort "You need to fill in your system";

      # here we define our username and hostname to reuse them later
      username = builtins.abort "You need to fill in your username"; # Set this variable equal to your username
      hostname = builtins.abort "You need to fill in your hostname"; # Set this variable equal to your hostname

      # the specialArgs are used to pass the inputs to the system configuration and home-manager configuration
      specialArgs = {
        inherit inputs username hostname;
      };
    in
    {
      # it is important that you use darwin.lib.darwinSystem as this is the builder that allow
      # for the configuration of the darwin system
      darwinConfigurations.${hostname} = darwin.lib.darwinSystem {

        # The specialArgs are used to pass the inputs to the system configuration
        inherit specialArgs;

        modules = [
          ./homebrew.nix
          ./users.nix

          # The home-manager module is used to configure home-manager
          # to read more about this please see ../home-manager
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            # extraSpecialArgs is used to pass the inputs to the home-manager configuration
            home-manager.extraSpecialArgs = specialArgs;

            # Here we have assume that the use is called "axel" but you can change that to your needs
            home-manager.users.${username} = import ./home.nix;
          }
        ];
      };
    };
}
