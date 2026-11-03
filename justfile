# Build and switch flakes
default: switch

build:
	sudo nixos-rebuild build --impure --flake .#nixos-desktop

# Switch flakes
switch:
	sudo nixos-rebuild switch --impure --flake .#nixos-desktop

update:
	sudo nix flake update
