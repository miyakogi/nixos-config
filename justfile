# Build and switch flakes
default: switch

build:
	nixos-rebuild build --impure --flake .#nixos-desktop

# Switch flakes
switch:
	sudo nixos-rebuild switch --impure --flake .#nixos-desktop

update:
	nix flake update
