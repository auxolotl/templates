{ stdenv, gnumake }:
stdenv.mkDerivation {
  name = "hello";

  src = ./.;
  nativeBuildInputs = [ gnumake ];

  enableParallelBuilding = true;

  installPhase = ''
    install -D hello $out/bin/hello --mode 0755
  '';
}
