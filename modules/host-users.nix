{
  hostname,
  username,
  pkgs,
  ...
}:
#############################################################
#
#  Host & Users configuration
#
#############################################################
{
  networking.hostName = hostname;
  networking.computerName = hostname;
  system.defaults.smb.NetBIOSName = hostname;
  time.timeZone = "Africa/Johannesburg";

  users.users."${username}" = {
    home = "/Users/${username}";
    description = username;
    packages = with pkgs; [ ];
  };
  system.primaryUser = username;

  nix.settings.trusted-users = [
    "root"
    username
  ];
}
