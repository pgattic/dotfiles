# Use the AppImage version of BambuStudio (The native one is broken)
{
  perSystem = { pkgs, ... }: let
    bambu-studio = pkgs.appimageTools.wrapType2 rec {
      name = "BambuStudio";
      pname = "bambu-studio";
      version = "02.05.00.65";
      ubuntu_version = "24.04_PR-9504";

      src = pkgs.fetchurl {
        url = "https://github.com/bambulab/BambuStudio/releases/download/v${version}/Bambu_Studio_ubuntu-${ubuntu_version}.AppImage";
        sha256 = "sha256-tVjzyV0kEf5kx0C4PvxeS3+FOQZKtPuVRJkiLeQQFhc=";
      };

      profile = ''
        export SSL_CERT_FILE="${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
        export GIO_MODULE_DIR="${pkgs.glib-networking}/lib/gio/modules/"
      '';

      extraPkgs = pkgs: with pkgs; [
        cacert
        glib
        glib-networking
        gst_all_1.gst-plugins-bad
        gst_all_1.gst-plugins-base
        gst_all_1.gst-plugins-good
        webkitgtk_4_1
      ];
    };
  in {
    overlayAttrs = { inherit bambu-studio; };
    packages = { inherit bambu-studio; };
  };
}

