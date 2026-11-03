{ ... }: {
  programs.gitui = {
    enable = true;
    keyConfig = ./key_bindings.ron;
    theme = ./theme.ron;
  };
}
