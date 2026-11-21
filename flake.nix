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
      inputs.meltype-src.url = "github:yksr-melt/Meltype/v1.7.0";
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
    # niri source carrying the force-render window rule from
    # https://github.com/niri-wm/niri/pull/4392 (draft PR).
    niri-src = {
      url = "github:MithicSpirit/niri/force-render-v2";
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
        patches = [
          ./home/patches/nix-meltype-session-vars.patch
          # Meltype 1.7.0 moved the NativeAOT project from src/Meltype.Mac.Native to
          # src/Meltype.Core.CApi; nix-meltype still points at the old path.
          ./home/patches/nix-meltype-native-project-path.patch
        ];
      };
      # Import the patched flake so that the module and the packages it installs
      # (meltype, fcitx5-meltype) all come from the patched tree. The outputs
      # function does not use `self`, so an empty set is enough.
      meltypeOutputs = (import "${meltypeSrc}/flake.nix").outputs {
        self = { };
        nixpkgs = inputs.nixpkgs;
        meltype-src = inputs.nix-meltype.inputs.meltype-src;
      };
      meltypeModule = meltypeOutputs.homeModules.default;
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
