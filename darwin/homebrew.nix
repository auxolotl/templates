{ config, ... }:
{
  config = {
    environment = {
      # You can configure your usual shell environment for homebrew here.
      variables = {
        HOMEBREW_NO_ANALYTICS = "1";
        HOMEBREW_NO_INSECURE_REDIRECT = "1";
        HOMEBREW_NO_EMOJI = "1";
        HOMEBREW_NO_ENV_HINTS = "0";
      };

      # This is included so that the homebrew packages are available in the PATH.
      systemPath = [ config.homebrew.brewPrefix ];
    };

    # homebrew need to be installed manually, see https://brew.sh
    # The apps installed by homebrew are not managed by nix, and not reproducible!
    homebrew = {
      enable = true;
      caskArgs.require_sha = true;

      onActivation = {
        autoUpdate = true;
        upgrade = true;
        # 'zap': uninstalls all formulae(and related files) not listed here.
        cleanup = "zap";
      };

      # Applications to install from Mac App Store using mas.
      # You need to install all these Apps manually first so that your apple account have records for them.
      # otherwise Apple Store will refuse to install them.
      # For details, see https://github.com/mas-cli/mas
      masApps = { };

      taps = [ "homebrew/bundle" ];

      # This is the equivalent of running `brew install`
      brews = [
        "curl"
        "openjdk"
      ];

      # This is the equivalent of running `brew install --cask`
      casks = [
        "arc" # browser
        "zed" # text editor
        "raycast" # app launcher, and clipboard manager
        "obsidian" # note taking
        "inkscape" # vector graphics editor
      ];
    };
  };
}
