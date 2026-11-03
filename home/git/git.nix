{ pkgs, ... }: {
  home.packages = with pkgs; [
    delta
    difftastic
    gh
  ];

  programs.git = {
    enable = true;
    ignores = [
      # Vim
      "[._]*.s[a-w][a-z]"
      "[._]s[a-w][a-z]"
      "*.un~"

      # Editor / AI
      "opencode.jsonc"
      ".opencode/"
      ".commandcode/"
      ".cline/"

      # File system
      ".directory"
      ".fuse*"

      # Python
      "__pycache__/"
      "*.py[cod]"
      "*$py.class"
      "*.so"
      ".Python"
      "develop-eggs/"
      "dist/"
      "eggs/"
      ".eggs/"
      "sdist/"
      "*.egg-info/"
      "*.egg"
      "pip-selfcheck.json"
      ".venv"
      ".coverage"
      ".coverage.*"
      ".cache"
      "coverage.xml"
      ".mypy_cache"
      "*.mo"
      "*.pot"
      ".doit.db"

      # Environment
      ".env"
      ".envrc"
      ".direnv/"

      # Temporary
      "*.bak"
    ];
    settings = {
      core = {
        quotepath = false;
        preloadindex = true;
        autoCRLF = false;
        pager = "delta";
      };
      include = {
        path = "config.local";
      };
      init = {
        defaultBranch = "main";
      };
      color = {
        ui = "auto";
        diff = "auto";
        status = "auto";
        branch = "auto";
      };
      interactive = {
        diffFilter = "delta --color-only";
      };
      "add.interactive" = {
        userBuiltin = false;
      };
      delta = {
        navigate = true;
        features = "side-by-side ansi clean-style";
        side-by-side = {
          side-by-side = true;
        };
        ansi = {
          syntax-theme = "ansi";
        };
        clean-style = {
          line-numbers-left-format = "{nm:>4}|";
          line-numbers-right-format = "{np:>4}|";
          line-numbers-minus-style = "red normal";
          line-numbers-plus-style = "green normal";
          minus-style = "red normal";
          minus-emph-style = "red bold normal";
          plus-style = "green normal";
          plus-emph-style = "green bold normal";
        };
        signs = {
          keep-plus-minus-markers = true;
        };
      };
      alias = {
        clone-shallow = "clone --depth=1";
        hist = ''log --pretty=format:"%C(magenta)%h %C(cyan)%ad%Creset - %s %C(dim)<%C(italic)%an%Creset%C(dim)>%Creset%C(yellow)%d%Creset" --graph --date=short'';
      };
      merge = {
        ff = false;
        conflictstyle = "diff3";
      };
      diff = {
        tool = "difftastic";
        colorMoved = "default";
      };
      difftool = {
        prompt = false;
        difftastic = {
          cmd = ''difft --display side-by-side-show-both "$LOCAL" "$REMOTE"'';
        };
      };
      pager = {
        difftool = true;
      };
      push = {
        default = "simple";
      };
      pull = {
        rebase = false;
        ff = true;
      };
      url = {
        "github:" = {
          pushInsteadOf = [
            "https://github.com/"
            "git@github.com:"
          ];
        };
      };
    };
  };
}
