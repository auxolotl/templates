{
  description = "An empty devshell with direnv support";

  inputs.nixpkgs.url = "github:auxolotl/nixpkgs/nixpkgs-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShell { packages = [ pkgs.hello ]; };
    };
}
