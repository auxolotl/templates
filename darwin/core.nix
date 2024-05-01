{
  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  nix.settings = {
    # We need this to be able to use the nix-command and flakes features.
    # these are essential to use this system configuration as a flake.
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    # this allows the system builder to use substitutes
    builders-use-substitutes = true;

    # we want these beacuse we don't have to build every package from source
    substituters = [ "https://nix-community.cachix.org" ];
    trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];

    # We also want to add our user, in this case "axel" to the trusted users
    # this is important so that we can use the substituters with no issues
    trusted-users = [ "axel" ];
  };
}
