{
  description = "Templates for getting started with Aux";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

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
        ] (system: function nixpkgs.legacyPackages.${system});
    in
    {
      templates = {
        default = self.templates.system;
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
        direnv = {
          path = ./direnv;
          description = "An empty devshell with direnv support";
        };
      };
      formatter = forAllSystems (pkgs: pkgs.nixfmt-rfc-style);
    };
}
