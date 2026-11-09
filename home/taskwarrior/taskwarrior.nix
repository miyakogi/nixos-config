{ pkgs, ... }:
let
  # nixpkgs' cargo setup hook forces system libraries, which makes
  # libsqlite3-sys link against system sqlite. Taskwarrior's C++ executables
  # then link taskchampion's staticlib without -lsqlite3, so keep the
  # vendored sqlite instead.
  taskwarrior3 = pkgs.taskwarrior3.overrideAttrs (_: {
    dontCargoUseSystemLibs = true;
  });
in
{
  programs.taskwarrior = {
    enable = true;
    package = taskwarrior3;
  };
}
