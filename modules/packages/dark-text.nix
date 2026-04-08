# Customized version of dark-text from https://github.com/vimjoyer/dark-text
# Strips out audio dependencies, uses noctalia-qs instead of normal quickshell
{ inputs, ... }: {
  perSystem = { pkgs, ... }: let
    dark-text-src = inputs.dark-text-src;
    FONTCONFIG_FILE =
      pkgs.makeFontsConf { fontDirectories = [ pkgs.eb-garamond ]; };

    TEXT_SHADER = pkgs.runCommand "shader.qsb" {} ''
      ${pkgs.lib.getExe pkgs.kdePackages.qtshadertools} \
        --qt6 -o $out ${dark-text-src + "/shaders/rays.frag"}
    '';

    OVERLAYS = map (f: pkgs.lib.strings.removeSuffix ".qml" f)
      (builtins.attrNames (builtins.readDir (dark-text-src + "/shells")));

    dark-text = pkgs.writeShellApplication {
      name = "dark-text";
      runtimeInputs = [ pkgs.noctalia-qs ];
      bashOptions = [ "errexit" "pipefail" ];

      text = ''
        export FONTCONFIG_FILE=${FONTCONFIG_FILE}
        export TEXT_SHADER=${TEXT_SHADER}

        OVERLAYS=(${
          builtins.concatStringsSep " "
          (map (s: ''"'' + s + ''"'') OVERLAYS)
        })

        : "''${DARK_TEXT:=Hello, World!}"
        : "''${DARK_COLOR:-}"
        : "''${DARK_DURATION:=10000}"
        : "''${OVERLAY:=victory}"
        : "''${SHOW_OVERLAY:=true}"

        show_overlay() {
          exec quickshell -p "${dark-text-src + "/shells"}/$1.qml" > /dev/null
        }

        contains() {
          local item=$1
          shift
          for x in "$@"; do
            if [[ "$x" == "$item" ]]; then
              return 0
            fi
          done
          return 1
        }

        show_help() {
        cat <<EOF
        Usage: dark-text [OPTIONS]

        Options:
          -t, --text <TEXT>       Text to display [default: Hello, World!]
          -c, --color <COLOR>     Text color [default: #fad049]
          -d, --duration <MS>     Duration in milliseconds [default: 10000]
          -o, --overlay           Overlay to display [default: victory]
                                  Available overlays: ${
                                    pkgs.lib.concatStringsSep " " OVERLAYS
                                  }
          --no-display            Don't display overlay
          --death                 Dark souls death preset
          --new-area              Dark souls new area preset
          -h, --help              Print help
        EOF
        }

        while [[ $# -gt 0 ]]; do
          case "$1" in
            -t|--text)
              DARK_TEXT="$2"
              shift 2
              ;;
            -c|--color)
              DARK_COLOR="$2"
              shift 2
              ;;
            -d|--duration)
              DARK_DURATION="$2"
              shift 2
              ;;
            -o|--overlay)
              if contains "$2" "''${OVERLAYS[@]}"; then
                OVERLAY="$2"
              else
                echo "Unknown overlay. Available overlays: ''${OVERLAYS[*]}"
                exit 1
              fi
              shift 2
              ;;
            --no-display)
              SHOW_OVERLAY=false
              shift
              ;;
            --death)
              DARK_DURATION=6500
              DARK_COLOR="#A01212"
              shift
              ;;
            --new-area)
              OVERLAY="new_area"
              DARK_DURATION=4500
              shift
              ;;
            -h|--help)
              show_help
              exit 0
              ;;
            *)
              echo "Unknown option: $1"
              show_help
              exit 1
              ;;
          esac
        done

        export DARK_TEXT DARK_COLOR DARK_DURATION

        if $SHOW_OVERLAY; then
          show_overlay "$OVERLAY"
        fi
      '';
    };
  in {
    overlayAttrs = { inherit dark-text; };
    packages = { inherit dark-text; };
  };
}

