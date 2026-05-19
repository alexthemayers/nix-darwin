deploy:
	nix build .#darwinConfigurations."Alexanders-MacBook-Pro".system \
	   --extra-experimental-features 'nix-command flakes'

	sudo -E ./result/sw/bin/darwin-rebuild switch --flake .#Alexanders-MacBook-Pro