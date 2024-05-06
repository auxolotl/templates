{
  cargoMeta,
  pkgs,
  mkShell,
  fenixRustToolchain,
  bashInteractive,
  cargo-edit,
  reuse,
  just,
  eclint,
}:

mkShell {

  inputsFrom = [ pkgs.${cargoMeta.package.name} ];

  packages = [
    fenixRustToolchain

    bashInteractive

    # for upgrading dependencies (i.e. versions in Cargo.toml)
    cargo-edit

    reuse
    just
    eclint
  ];

  shellHook = ''
    unset SOURCE_DATE_EPOCH
    just --list --list-heading $'just <task>:\n'
  '';
}
