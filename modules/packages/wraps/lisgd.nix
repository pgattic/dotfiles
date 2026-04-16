{
  perSystem = { pkgs, ... }: let
    rotate-screen = pkgs.writeShellScriptBin "rotate-screen" ''
      #!/usr/bin/env bash

      MONITOR="''${1:-DSI-1}"

      if niri msg outputs | grep -A7 "$MONITOR" | grep -q "Transform: normal"; then
        niri msg output "$MONITOR" transform 270
      else
        niri msg output "$MONITOR" transform normal
      fi
    '';
  in {
    packages = {
      lisgd-op6 = pkgs.writeShellApplication {
        name = "lisgd-op6";
        runtimeInputs = [
          pkgs.lisgd
          pkgs.niri
        ];
        text = ''
          sleep 5; exec lisgd \
            -d /dev/input/by-path/platform-a90000.i2c-event \
            -t 10 -T 5 \
            -g "1,DU,B,*,R,niri msg action toggle-overview" \
            -g "1,UD,T,*,R,niri msg action fullscreen-window" \
            -g "1,LR,B,*,R,niri msg action focus-column-left" \
            -g "1,RL,B,*,R,niri msg action focus-column-right" \
            -g "1,LR,L,*,R,niri msg action focus-column-left" \
            -g "1,RL,R,*,R,niri msg action focus-column-right" \
            -g "1,LR,T,*,R,${rotate-screen}/bin/rotate-screen"
        '';
      };
      lisgd-surface = pkgs.writeShellApplication {
        name = "lisgd-surface";
        runtimeInputs = [
          pkgs.lisgd
          pkgs.niri
        ];
        text = ''
          sleep 5; exec lisgd \
            -d /dev/input/event29 \
            -t 10 -T 5 \
            -g "1,DU,B,*,R,niri msg action toggle-overview" \
            -g "1,UD,T,*,R,niri msg action fullscreen-window" \
            -g "1,LR,B,*,R,niri msg action focus-column-left" \
            -g "1,RL,B,*,R,niri msg action focus-column-right" \
            -g "1,LR,L,*,R,niri msg action focus-column-left" \
            -g "1,RL,R,*,R,niri msg action focus-column-right" \
            -g "1,LR,T,*,R,${rotate-screen}/bin/rotate-screen"
        '';
      };
    };
  };
}

