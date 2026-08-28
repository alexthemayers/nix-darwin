{
  hostname,
  username,
  ...
}:
{
  networking.hostName = hostname;
  networking.computerName = hostname;
  system.defaults.smb.NetBIOSName = hostname;
  time.timeZone = "Africa/Johannesburg";

  users.users."${username}" = {
    home = "/Users/${username}";
    description = username;
  };
  system.primaryUser = username;

  nix.settings.trusted-users = [
    "root"
    username
  ];
}
