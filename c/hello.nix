{ stdenv }:
stdenv.mkDerivation {
  name = "hello";
  src = ./.;

  env.BINDIR = "${placeholder "out"}/bin";
}
