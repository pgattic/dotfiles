
# .dotfiles

pgattic's NixOS dotfiles

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
{ inputs, withSystem, ... }: {
  flake.nixosConfigurations.new-computer = withSystem "x86_64-linux" ({ pkgs, self', ... }: inputs.nixpkgs.lib.nixosSystem {
    modules = [
      ./_hardware.nix
      inputs.self.nixosModules.options
      inputs.self.nixosModules.default
      inputs.self.nixosModules.desktop-default
      inputs.self.nixosModules.browser
      ({ pkgs, ... }: {
        networking.hostName = "new-computer";
        system.stateVersion = "25.05";

        # Examples of modifying config values (consult `/modules/options.nix` for more info)
        my.user.name = "pgattic";
        my.desktop.touch_options = true;

        environment.systemPackages = [
          self'.packages.foot
          pkgs.rnote
        ];

        # Example of adding some home-manager config
        home-manager.users.${config.my.user.name}.programs.chromium = {
          enable = true;
          package = pkgs.ungoogled-chromium;
        };
      })
    ];
  });
}
```
6. Rebuild the system with `nh os switch /home/pgattic/dotfiles#new-computer` (subsequent rebuilds can be done with simply `nh os switch`)
7. (Optional) to set up remote building, include the `remote-builder` module, then generate a root-level ssh key to paste into `./modules/hosts/corlessfam/default.nix`:
```bash
sudo ssh-keygen -t ed25519 -f /root/.ssh/nixbuilder_ed25519 -C "nixbuilder-new-computer"
sudo cat /root/.ssh/nixbuilder_ed25519.pub | wl-copy
```

## Notes

- With a remote builder, some packages which have a `preferLocalBuild` option may still build locally. Force a remote build with `--option max-jobs 0`, and force a local build with `--option builders ''`.

