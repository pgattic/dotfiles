{
  flake.nixosModules.remote-builder = { config, lib, ... }: lib.mkIf (config.networking.hostName != "corlessfam") {
    nix = {
      distributedBuilds = true;
      buildMachines = [
        {
          hostName = "corlessfamily.net";
          protocol = "ssh-ng";
          sshUser = "nixbuilder";
          sshKey = "/root/.ssh/nixbuilder_ed25519";
          systems = [
            "x86_64-linux"
            "aarch64-linux"
          ];
          maxJobs = 4;
          speedFactor = 2;
          supportedFeatures = [ "big-parallel" ];
        }
      ];

      settings = {
        builders-use-substitutes = true;
        max-jobs = lib.mkDefault 1;
      };
    };
  };
}
