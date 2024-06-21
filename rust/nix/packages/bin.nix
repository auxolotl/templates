{
  lib,
  flake-self,
  cargoMeta,
  rustPlatform,
}:
let
  fs = lib.fileset;
  sourceFiles = fs.unions [
    (fs.maybeMissing ../../src)
    (fs.maybeMissing ../../Cargo.toml)
    (fs.maybeMissing ../../Cargo.lock)
  ];
in
rustPlatform.buildRustPackage {
  inherit (cargoMeta.package) version;
  pname = cargoMeta.package.name;

  src = fs.toSource {
    root = ../../.;
    fileset = sourceFiles;
  };

  cargoLock.lockFile = ../../Cargo.lock;

  VERGEN_IDEMPOTENT = "1";
  VERGEN_GIT_SHA =
    if flake-self ? "rev" then
      flake-self.rev
    else if flake-self ? "dirtyRev" then
      flake-self.dirtyRev
    else
      lib.warn "no git rev available" "NO_GIT_REPO";
  VERGEN_GIT_BRANCH = if flake-self ? "ref" then flake-self.ref else "";
  VERGEN_GIT_COMMIT_TIMESTAMP = flake-self.lastModifiedDate;
}
