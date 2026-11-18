# Build and switch flakes
default: switch

build:
	nixos-rebuild build --impure --flake .#nixos-desktop

# Switch flakes
switch:
	sudo nixos-rebuild switch --impure --flake .#nixos-desktop

# Format every tracked Nix file
fmt:
	nix fmt $(git ls-files '*.nix')

# Check that every tracked Nix file is formatted
fmt-check:
	nix fmt -- --check $(git ls-files '*.nix')

update:
	nix flake update
