# This section apply settings to the system configuration only available on macOS
# see <https://daiderd.com/nix-darwin/manual/index.html#sec-options> for more options
{
  system = {
    # Add ability to used TouchID for sudo authentication
    security.pam.enableSudoTouchIdAuth = true;

    # Create /etc/zshrc that loads the nix-darwin environment.
    # this is required if you want to use darwin's default shell - zsh
    programs.zsh.enable = true;
  };
}
