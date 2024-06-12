> [!WARNING]
> **This repository has moved!**<br/>
> You can contribute or find up-to-date content at https://git.auxolotl.org/auxolotl/templates

<p align="center">
  <h2 align="center">Welcome to Aux</h2>
</p>

<p align="center">
	This is a template repository for getting started with your brand new Auxolotl system.
</p>

<p align="center">
  <a href="https://forum.aux.computer/c/special-interest-groups/sig-documentation/21"><img src="https://img.shields.io/static/v1?label=Maintained%20By&message=SIG%20Documentation&style=for-the-badge&labelColor=222222&color=794AFF" /></a>
  <a href="https://forum.aux.computer/c/special-interest-groups/sig-core/14"><img src="https://img.shields.io/static/v1?label=Maintained%20By&message=SIG%20Core&style=for-the-badge&labelColor=222222&color=794AFF" /></a>
</p>

&nbsp;

### Getting Started

There are 3 main templates in this repository:
- `darwin` - The system configuration for the Darwin operating system (macOS)
- `system` - The system configuration for the Linux operating system
- `home-manager` - The configuration for the home-manager

#### With Darwin (macOS)

1. Run `nix --extra-experimental-features nix-command --extra-experimental-features flakes flake new -t github:auxolotl/templates#darwin NixFiles` in the terminal. This will setup the basic configuration for the system, this generate a configuration for you from the files located in the `darwin` directory.
2. The next step is to go into the `NixFiles` directory this can be achieved by running `cd NixFiles`.
3. Now we you need to read over the configuration files and make any changes that you see fit, some of these must include changing your username and hostname.
4. You now must rebuild this configuration we can do this with `nix run darwin -- switch --flake .#hostname` hostname should be substituted for your systems hostname.
5. After your first run you are now able to use the `darwin-rebuild switch --flake .` command to rebuild your system.

#### With NixOS

1. Run `nix --extra-experimental-features nix-command --extra-experimental-features flakes flake new -t github:auxolotl/templates#system NixFiles`
2. Move into your new system with `cd NixFiles`
3. Fill in your `hostName` in `flake.nix`
4. Run `nixos-generate-config --show-hardware-config > hardware-configuration.nix` to generate configuration based on your filesystems and drivers
5. Run `nixos-rebuild build --flake .#hostName`, replacing hostName with your new hostName

Congratulations, you are now using Aux!

#### With Home-manager

1. Run `nix --extra-experimental-features nix-command --extra-experimental-features flakes flake new -t github:auxolotl/templates#home-manager NixFiles` to start
2. Move into your new Nix system with `cd NixFiles`
3. Fill in your `username` in `flake.nix`
