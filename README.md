## Welcome to Aux

This is a template repository for getting started with your brand new FreshwaterOS system.

### Getting Started

There are 3 main templates in this repository:
- `darwin` - The system configuration for the Darwin operating system (macOS)
- `system` - The system configuration for the Linux operating system
- `home-manager` - The configuration for the home-manager

#### With Darwin (macOS)

1. Run `nix flake new -t github:auxolotl/templates#darwin NixFiles` in the terminal. This will setup the basic configuration for the system, this generate a configuration for you from the files located in the `darwin` directory.
2. The next step is to go into the `NixFiles` directory this can be achieved by running `cd NixFiles`.
3. Now we you need to read over the configuration files and make any changes that you see fit, some of these must include changing your username and hostname.
4. You now must rebuild this configuration we can do this with `darwin-rebuild switch --flake .`. This assumes that your host name has not changed.

#### With Linux

1. Run `nix flake new -t github:auxolotyl/templates#system NixFiles`
2. Move into your new system with `cd NixFiles`
3. Fill in your `hostName` and `username` in `flake.nix`
4. Run `nixos-generate-config --show-hardware-config > hardware-configuration.nix` to generate configuration based on your filesystems and drivers
5. Run `sudo nixos-rebuild build --flake .#hostName`, replacing hostName with your new hostName

Congratulations, you are now using Aux!

#### With Home-manager

1. Run `nix flake new -t github:auxolotyl/templates#home-manager NixFiles` to start
2. Move into your new Nix system with `cd NixFiles`
3. Fill in your `username` in `flake.nix`
