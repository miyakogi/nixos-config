{ inputs, pkgs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) system;
in
{
  programs.helix = {
    enable = true;
    # Helix's grammars.nix fetches every grammar source during evaluation, and
    # the upstream tree-sitter-cylc repository has been deleted (HTTP 404).
    # Exclude the unused grammar so evaluation does not depend on the fetcher
    # cache being warm.
    package = inputs.helix.packages.${system}.default.override {
      includeGrammarIf = grammar: grammar.name != "cylc";
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
