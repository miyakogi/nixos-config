{ ... }: {
  programs.neovim = {
    enable = true;
    withRuby = false;
    withPython3 = true;
    initLua = builtins.readFile ./init.lua;
  };

  xdg.configFile."nvim/manrc" = {
    source = ./manrc;
  };
  xdg.configFile."nvim/lua" = {
    source = ./lua;
    recursive = true;
  };
  xdg.configFile."nvim/after" = {
    source = ./after;
    recursive = true;
  };
  xdg.configFile."nvim/ftplugin" = {
    source = ./ftplugin;
    recursive = true;
  };
  xdg.configFile."nvim/snippets" = {
    source = ./snippets;
    recursive = true;
  };

}
