{
  flake.nixosModules.remote-builder = { config, lib, ... }: let
    builderHostName = "corlessfam";
    builderEndpoint = "corlessfamily.net";
  in lib.mkIf (config.networking.hostName != builderHostName) {
    nix = {
      distributedBuilds = true;
      buildMachines = [
        {
          hostName = builderEndpoint;
          protocol = "ssh-ng";
          sshUser = "nixbuilder";
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
