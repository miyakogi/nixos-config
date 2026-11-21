{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.i18n.inputMethod.fcitx5-mozkey;
in
{
  options.i18n.inputMethod.fcitx5-mozkey = {
    enable = lib.mkEnableOption "the Mozkey Japanese input method for fcitx5";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.fcitx5-mozkey;
      defaultText = lib.literalExpression "pkgs.fcitx5-mozkey";
      description = "The fcitx5-mozkey package to install.";
    };
  };

  config = lib.mkIf cfg.enable {
    i18n.inputMethod = {
      enable = lib.mkDefault true;
      type = lib.mkDefault "fcitx5";
      fcitx5.addons = [ cfg.package ];
    };
  };
}
