{
  description = "Templates for getting started with Aux";

  inputs.nixpkgs.url = "github:auxolotl/nixpkgs/nixpkgs-unstable";

  outputs =
    { self, nixpkgs }:
    let
      forAllSystems =
        function:
        nixpkgs.lib.genAttrs [
          "x86_64-linux"
          "aarch64-linux"
          "x86_64-darwin"
          "aarch64-darwin"
        ] (system: function system);
    in
    {
      templates = {
        default = self.templates.direnv;
        system = {
          path = ./system;
          description = "";
        };
        home-manager = {
          path = ./home-manager;
          description = "";
        };
        darwin = {
          path = ./darwin;
          description = "";
        };
      };
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);
    };
}
