{
  description = "An empty devshell with direnv support";

  inputs.nixpkgs.url = "github:auxolotl/nixpkgs/nixpkgs-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      forAllSystems =
        function:
        nixpkgs.lib.genAttrs [
          "x86_64-linux"
          "aarch64-linux"
          "x86_64-darwin"
          "aarch64-darwin"
        ] (system: function nixpkgs.legacyPackages.${system});
    in
    {
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShellNoCC {
          packages = [ pkgs.hello ];
          EXAMPLE_VAR = "inside the direnv template";
          shellHook = ''
            echo "Hello from $EXAMPLE_VAR, $(whoami)!"
          '';
        };
      });
    };
}
