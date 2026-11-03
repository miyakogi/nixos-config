{ ... }: {
  programs.cargo = {
    enable = true;
    package = null;
    settings = {
      cargo-new = {
        vcs = "none";
      };
      "target.x86_64-unknown-linux-gnu" = {
        linker = "clang";
        rustflags = [
          "-C"
          "link-arg=-fuse-ld=mold"
        ];
      };
      term = {
        color = "auto";
      };
      net = {
        retry = 2;
      };
    };
  };
}
