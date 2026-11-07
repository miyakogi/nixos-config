{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
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
      inputs.meltype-src.url = "github:yksr-melt/Meltype/v1.4.1-pre.6";
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
        meltypePkgs: meltypePkgs.extend inputs.nix-meltype.overlays.default
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
