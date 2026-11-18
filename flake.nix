{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak = {
      url = "github:gmodena/nix-flatpak";
    };
    nix-hazkey = {
      url = "github:aster-void/nix-hazkey";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-meltype = {
      url = "github:aster-void/nix-meltype";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.meltype-src.url = "github:yksr-melt/Meltype/v1.6.0";
    };
    helix = {
      url = "github:helix-editor/helix";
    };
    waybar = {
      url = "github:Alexays/Waybar";
    };
    shaders = {
      url = "github:miyakogi/Anime4K-mpv-glsl";
      flake = false;
    };
  };

  outputs =
    { nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };

      meltypeSrc = pkgs.applyPatches {
        name = "nix-meltype-patcked";
        src = inputs.nix-meltype.outPath;
        patches = [ ./home/patches/nix-meltype-session-vars.patch ];
      };
      meltypeModule = import "${meltypeSrc}/modules/home-manager.nix" (
        meltypePkgs:
        (meltypePkgs.extend inputs.nix-meltype.overlays.default).extend (
          _final: prev: {
            fcitx5-meltype = prev.fcitx5-meltype.overrideAttrs (old: {
              # The addon shows the mode indicator on a 30 ms timer; the test checks 100 ms after
              # focus-in. In the Nix build both timers can become due in the same event-loop wake and
              # the test's timer runs first, so auxUp is still empty. The indicator stays 1200 ms;
              # wait 500 ms instead.
              postPatch = (old.postPatch or "") + ''
                substituteInPlace test/testmeltype.cpp \
                  --replace-fail "now(CLOCK_MONOTONIC) + 100000" "now(CLOCK_MONOTONIC) + 500000"
              '';
            });
          }
        )
      );
    in
    {
      formatter.x86_64-linux = pkgs.nixfmt;

      nixosConfigurations = {
        nixos-desktop = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./configuration.nix
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs; };

                users.miyaco = {
                  imports = [
                    meltypeModule
                    ./home/home.nix
                  ];
                };
              };
            }
          ];
        };
      };
    };
}
