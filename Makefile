# --extra-experimental-features: needed before this flake's nix settings
# (nix-command + flakes) have been applied on a fresh machine.
deploy-m3pro:
	nix build .#darwinConfigurations."m3pro".system \
	   --extra-experimental-features 'nix-command flakes'

	sudo -E ./result/sw/bin/darwin-rebuild switch --flake .#m3pro

deploy-work:
	nix build .#darwinConfigurations."work".system \
	   --extra-experimental-features 'nix-command flakes'

	sudo -E ./result/sw/bin/darwin-rebuild switch --flake .#work

lint:
	nix flake check --all-systems

fmt:
	nix fmt
