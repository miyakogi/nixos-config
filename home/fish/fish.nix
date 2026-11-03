{ pkgs, ... }: {
  xdg.configFile."fish/functions" = {
    source = ./functions;
    recursive = true;
  };
  xdg.configFile."fish/themes" = {
    source = ./themes;
    recursive = true;
  };

  # improved completion
  programs.carapace = {
    enable = true;
    enableBashIntegration = false; # conflict with blesh
    enableFishIntegration = true;
    enableZshIntegration = true;
  };

  programs.fish = {
    enable = true;

    shellAbbrs = {
      ":q" = "exit";

      c = "cd";

      rm = "trash put";

      l = "ls";

      ln = "ln -s -v";

      e = "edit";
      n = "nvim";
      h = "hx";

      gstatus = "git status -s -b";

      t = "btop";
      b = "btm";
    };

    shellAliases = {
      cp = "cp -i";
      mv = "mv -i";
      mkdir = "mkdir -p";
    };

    functions = {
      fish_greeting = ''
        if ! status is-login
          if type -q fastfetch
            fastfetch --config config-short.jsonc
          else if type -q macchina
            macchina
          end
        end
      '';
      __auto_ls = {
        onVariable = "PWD";
        body = "ls";
      };
    };

    binds = {
      "ctrl-w".command = "backward-kill-word";
      "ctrl-backspace".command = "backward-kill-word";
      "ctrl-y".command = [
        "commandline \"cd ../\""
        "commandline -f execute"
      ];
      "ctrl-j".command = "myjump";
    };

    plugins = [
      {
        name = "done";
        src = pkgs.fishPlugins.done.src;
      }
    ];

    loginShellInit = builtins.readFile ./login-shell.fish;
    interactiveShellInit = builtins.readFile ./interactive-shell.fish;
  };
}
