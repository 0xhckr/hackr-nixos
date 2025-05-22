{ pkgs, ... }:
{
  users.users.hackr = {
    description = "Mohammad Al-Ahdal";
    home = "/Users/hackr";
    shell = pkgs.nushell;
  };
}