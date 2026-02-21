let
  keys = {
    t480 =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN+tQ11EwCLxsnFls30h6ht7mEOAJ+JapnD61tzu/urS pgattic@gmail.com";
    corlessfam =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOEr1PnXeVIAfhaaPQUfEE66y9T7sZ8zvdxC3jfBdBLO pgattic@gmail.com";
    corlessfam_root =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICX9GZ7BgbubQe/hOOl2eCqhud/x2lb5vzSYskuK8a4f root@nixos";
  };
  all = builtins.attrValues keys;
in {
  "qbittorrent-pass.age" = { publicKeys = all; armor = true; };
  "namecheap-dns-env.age" = { publicKeys = all; armor = true; };
  "copyparty-pgattic.age" = { publicKeys = all; armor = true; };
  "copyparty-skylar.age" = { publicKeys = all; armor = true; };
  "romm-auth-secret-key.age" = { publicKeys = all; armor = true; };
  "romm-db-password.age" = { publicKeys = all; armor = true; };
  "romm-mariadb-root-password.age" = { publicKeys = all; armor = true; };
}

