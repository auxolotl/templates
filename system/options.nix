{ config, lib, ... }:
let
  inherit (lib.options) mkOption;
  inherit (lib.types) str;
in
{
  # More options can be added here.
  # Following the module system, any module option added in the `options.aux` attribute set
  # will become available under `config.aux` within your configuration. Thus making it
  # possible to reference arbitrary internal variables if they have been set here
  options.aux = {
    hostname = mkOption {
      type = str;
      default = builtins.throw "hostname is required";
      description = "The hostname for the machine";
    };
  };

  config = {
    # internally set `networking.hostName` to the value of `aux.hostname`
    # similarly, you can set the values of nixpkgs module system options
    # to the variable options defined under `options.aux`
    networking.hostName = config.aux.hostname;
  };
}
