{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) system;
in
{
  programs.helix = {
    enable = true;
    # Helix's grammars.nix fetches every grammar source during evaluation:
    # - the upstream tree-sitter-cylc repository has been deleted (HTTP 404)
    # - codeberg.org currently answers NXDOMAIN, so every grammar hosted there
    #   (go-format-string, lua-format-string, prolog, mail, spade, shellcheckrc,
    #   gnuplot, proverif, ptx) cannot be fetched either
    # Exclude them so evaluation does not depend on those remotes; drop the
    # codeberg clause once the domain resolves again.
    package = inputs.helix.packages.${system}.default.override {
      includeGrammarIf =
        grammar:
        grammar.name != "cylc" && !(lib.hasPrefix "https://codeberg.org" (grammar.source.git or ""));
    };
  };

  xdg.configFile."helix/config.toml" = {
    source = ./config.toml;
  };
  xdg.configFile."helix/languages.toml" = {
    source = ./languages.toml;
  };
  xdg.configFile."helix/themes" = {
    source = ./themes;
    recursive = true;
  };
}
