{
  perSystem = { pkgs, ... }: {
    packages = {
      lisgd-mobile = pkgs.writeShellApplication {
        name = "lisgd-mobile";
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
            -g "1,LR,L,*,R,niri msg action focus-column-left" \
            -g "1,RL,R,*,R,niri msg action focus-column-right"
        '';
      };
    };
  };
}

