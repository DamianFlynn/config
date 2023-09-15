# NixOS

## Bootstrap

```bash 
sh <(curl -L https://nixos.org/nix/install) 
```

### Launch Environment

```bash
nix --extra-experimental-features "nix-command flakes" run github:damianflynn/nvim
```

This will install a custom version of neovim pre-configured for our environment.


### Build Environment

```bash
mkdir -p ~/Developer/damianflynn
git clone github:damianflynn/config
cd config

nix --extra-experimental-features "nix-command flakes" build .#darwinConfigurations.damianflynn.system

./result/sw/bin/darwin-rebuild switch --flake ~/Developer/damianflynn/config

nix flake show github:damianflynn/config
nix flakes update --recreate-lock-file

darwin-rebuild switch --flake ~/Developer/damianflynn/config/.#
```