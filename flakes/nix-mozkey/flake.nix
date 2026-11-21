{
  description = "Mozkey (Mozc fork) packaged for fcitx5 on NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Override this input to track another Mozkey revision, e.g.
    #   inputs.mozkey-src.url = "github:koyasi777/mozkey/main";
    #   inputs.mozkey-src.flake = false;
    # then run `nix flake update mozkey-src`.
    mozkey-src = {
      url = "github:koyasi777/mozkey/main";
      flake = false;
    };

    # fcitx5 engine sources, taken from fcitx/mozc at the Mozc 3.33 line
    # (Mozkey is based on Mozc 3.33.6153).
    fcitx-mozc-src = {
      url = "github:fcitx/mozc/02eaaa6dc82e629990b70b90f8dc37d0ff6741d5";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      mozkey-src,
      fcitx-mozc-src,
    }:
    let
      inherit (nixpkgs) lib;

      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      # Read the user-facing Mozkey release version from src/version.bzl so
      # that overriding mozkey-src also updates the package version.
      readVersionPart =
        prefix: lines:
        let
          line = lib.findFirst (l: lib.hasPrefix prefix l) "" lines;
          match = builtins.match "${prefix} *= *([0-9]+).*" line;
        in
        if match == null then "0" else builtins.head match;

      versionLines = lib.splitString "\n" (builtins.readFile (mozkey-src + "/src/version.bzl"));
      mozkeyVersion = lib.concatStringsSep "." (
        map (p: readVersionPart p versionLines) [
          "MOZKEY_RELEASE_VERSION_MAJOR"
          "MOZKEY_RELEASE_VERSION_MINOR"
          "MOZKEY_RELEASE_VERSION_PATCH"
        ]
      );

      mkPackage =
        pkgs:
        pkgs.callPackage ./nix/package.nix {
          inherit mozkey-src fcitx-mozc-src;
          version = mozkeyVersion;
        };
    in
    {
      overlays.default = final: _prev: {
        fcitx5-mozkey = mkPackage final;
      };

      packages = lib.genAttrs systems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          fcitx5-mozkey = mkPackage pkgs;
          default = mkPackage pkgs;
        }
      );

      nixosModules.default =
        { ... }:
        {
          imports = [ ./nix/module.nix ];
          nixpkgs.overlays = [ self.overlays.default ];
        };

      # Home Manager's i18n.inputMethod.fcitx5 module already handles session
      # variables, the systemd user service and fcitx5-with-addons. We only
      # need to install the package and register the addon.
      homeModules.default =
        { pkgs, lib, ... }:
        {
          imports = [ ./nix/module.nix ];
          i18n.inputMethod.fcitx5-mozkey.package = lib.mkDefault (mkPackage pkgs);
        };

      # Alias used by some configurations.
      homeManagerModules.default = self.homeModules.default;

      formatter = lib.genAttrs systems (system: nixpkgs.legacyPackages.${system}.nixfmt);
    };
}
