{
  config,
  inputs,
  pkgs,
  lib,
  ...
}: {
  programs.wofi.enable = true;
  programs.swaylock.enable = true;
  services.dunst.enable = true;
  home.pointerCursor = {
    name = "phinger-cursors";
    package = pkgs.phinger-cursors;
    gtk.enable = true;
    x11.enable = true;
  };

  wayland.windowManager.river = {
    enable = true;
    settings = {
      keyboard-layout = "-variant colemak_dh us";
      default-layout = "rivertile";
      map = {
        normal = {
          "Super+Shift Return" = "spawn kitty";
          "Super R" = "spawn 'wofi --show drun'";
          "Super Q" = "close";
          "Super+Shift E" = "exit";
          "Super K" = "focus-view previous";
          "Super J" = "focus-view next";
          "Super+Shift J" = "swap next";
          "Super+Shift K" = "swap previous";
          "Super Period" = "focus-output next";
          "Super Comma" = "focus-output previous";
          "Super+Shift Period" = "send-to-output next";
          "Super+Shift Comma" = "send-to-output previous";
          "Super Return" = "zoom";
          "Super H" = "send-layout-cmd rivertile main-ratio -0.05";
          "Super L" = "send-layout-cmd rivertile main-ratio +0.05";
          "Super+Shift H" = "send-layout-cmd rivertile main-count +1";
          "Super+Shift L" = "send-layout-cmd rivertile main-count -1";
          "Super+Alt H" = "move left 100";
          "Super+Alt J" = "move down 100";
          "Super+Alt K" = "move up 100";
          "Super+Alt L" = "move right 100";
          "Super+Alt+Control H" = "snap left";
          "Super+Alt+Control J" = "snap down";
          "Super+Alt+Control K" = "snap up";
          "Super+Alt+Control L" = "snap right";
          "Super+Alt+Shift H" = "resize horizontal -100";
          "Super+Alt+Shift J" = "resize vertical 100";
          "Super+Alt+Shift K" = "resize vertical -100";
          "Super+Alt+Shift L" = "resize horizontal 100";
        };
      };
    };
    extraSessionVariables = {
    };
    extraConfig = ''
      riverctl keyboard-layout -variant colemak_dh en

      riverctl map-pointer normal Super BTN_LEFT move-view
      riverctl map-pointer normal Super BTN_RIGHT resize-view
      riverctl map-pointer normal Super BTN_MIDDLE toggle-float
      riverctl map normal Super Space toggle-float
      riverctl map normal Super F toggle-fullscreen
      riverctl map normal Super Up    send-layout-cmd rivertile "main-location top"
      riverctl map normal Super Right send-layout-cmd rivertile "main-location right"
      riverctl map normal Super Down  send-layout-cmd rivertile "main-location bottom"
      riverctl map normal Super Left  send-layout-cmd rivertile "main-location left"

      for i in $(seq 1 9)
      do
          tags=$((1 << ($i - 1)))

          # Super+[1-9] to focus tag [0-8]
          riverctl map normal Super $i set-focused-tags $tags

          # Super+Shift+[1-9] to tag focused view with tag [0-8]
          riverctl map normal Super+Shift $i set-view-tags $tags

          # Super+Control+[1-9] to toggle focus of tag [0-8]
          riverctl map normal Super+Control $i toggle-focused-tags $tags

          # Super+Shift+Control+[1-9] to toggle tag [0-8] of focused view
          riverctl map normal Super+Shift+Control $i toggle-view-tags $tags
      done

      for mode in normal locked
      do
          # Control pulse audio volume with pamixer (https://github.com/cdemoulins/pamixer)
          riverctl map $mode None XF86AudioRaiseVolume  spawn 'pamixer -i 5'
          riverctl map $mode None XF86AudioLowerVolume  spawn 'pamixer -d 5'
          riverctl map $mode None XF86AudioMute         spawn 'pamixer --toggle-mute'

          # Control MPRIS aware media players with playerctl (https://github.com/altdesktop/playerctl)
          riverctl map $mode None XF86AudioMedia spawn 'playerctl play-pause'
          riverctl map $mode None XF86AudioPlay  spawn 'playerctl play-pause'
          riverctl map $mode None XF86AudioPrev  spawn 'playerctl previous'
          riverctl map $mode None XF86AudioNext  spawn 'playerctl next'
      done

      riverctl background-color 0x002b36
      riverctl border-color-focused 0x93a1a1
      riverctl border-color-unfocused 0x586e75

      rivertile -view-padding 6 -outer-padding 6 &
    '';
  };
}

