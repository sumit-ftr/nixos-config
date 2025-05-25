{ config, pkgs, ... }:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.opengl = {
    enable = true;
    driSupport = true;
  };
}
