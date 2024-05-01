{ username, hostname, ... }:
{
  # remember to set the hostname in the kernel command line
  networking.hostName = hostname;
  networking.computerName = hostname;
  system.defaults.smb.NetBIOSName = hostname;

  users.users."${username}".home = "/Users/${username}";
}
