{ pkgs, lib, ... }: {
  home.packages = [
    pkgs.blesh
  ];

  xdg.configFile."blesh/init.sh".source = ./blerc.bash;

  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      if [[ $- == *i* ]]; then
        source ${pkgs.blesh}/share/blesh/ble.sh
      fi
    '';
    initExtra = lib.mkAfter (builtins.readFile ./init-extra.bash);
  };
}
