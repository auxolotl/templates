{
  cargoMeta,
  pkgs,
  mkShell,
  fenixRustToolchain,
  bashInteractive,
  reuse,
  just,
  eclint,
  commitlint,
}:

mkShell {

  inputsFrom = [ pkgs.${cargoMeta.package.name} ];

  packages = [
    fenixRustToolchain

    bashInteractive

    reuse
    just
    eclint
    # nix develop ".#ci" --command --
    #  eclint
    #   -exclude "Cargo.lock"
    #   -exclude "flake.lock"

    commitlint
    # nix develop ".#ci" --command --
    #  commitlint
    #   --color false --verbose
    #   --from $(git rev-list --max-parents=0 HEAD | head -n 1)
    #   --to HEAD
  ];
}
