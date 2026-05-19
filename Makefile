deploy:
	nix build .#darwinConfigurations."m3pro".system \
	   --extra-experimental-features 'nix-command flakes'

	sudo -E ./result/sw/bin/darwin-rebuild switch --flake .#m3pro

fmt:
	nix fmt