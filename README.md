
# .dotfiles

This repository includes config files and scripts for their installation.

## Usage

Adding a device:

1. Install NixOS the normal way on the device
2. Ensure the following options are set in `/etc/nixos/configuration.nix`, then do a `sudo nixos-rebuild switch`:
```nix
nix.settings.experimental-features = [ "nix-command" "flakes" ];
environment.systemPackages = with pkgs; [ git neovim nh ];
```
3. `git clone https://github.com/pgattic/dotfiles`
4. Add a directory in [`/modules/hosts/`](/modules/hosts/) for the new device, and copy `/etc/nixos/hardware-configuration.nix` to the new dir under the name `_hardware.nix`.
5. Add a `default.nix` in the new directory with the example minimal configuration:
```nix
{ config, inputs, ... }: {
  flake.nixosConfigurations.new-computer = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ./_hardware.nix
      config.flake.nixosModules.options
      config.flake.nixosModules.default
      config.flake.nixosModules.desktop-default
      config.flake.nixosModules.browser
      ({ pkgs, ... }: {
        networking.hostName = "new-computer";
        system.stateVersion = "25.05";

        # Examples of modifying config values (consult `/modules/options.nix` for more info)
        my.user.name = "pgattic";
        my.user.home_dir = "/home/pgattic";
        my.desktop.touch_options = true;

        # Example of adding some home-manager config
        home-manager.users.${config.my.user.name} = {
          home.packages = with pkgs; [
            luanti-client
          ];
        };
      })
    ];
  };
}
```
6. Rebuild the system with `nh os switch /home/pgattic/dotfiles#new-computer` (subsequent rebuilds can be done with simply `nh os switch`)
7. Symlink the Neovim config with `mkdir -p /home/pgattic/.config/ && ln -s /home/user/dotfiles/config/nvim` (Neovim is the only thing not configured through Nix at this point)

