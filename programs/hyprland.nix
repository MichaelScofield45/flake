{
  config,
  inputs,
  pkgs,
  lib,
  ...
}: {
  programs.wofi.enable = true;
  services.dunst.enable = true;

  home.pointerCursor = {
    name = "phinger-cursors";
    package = pkgs.phinger-cursors;
    gtk.enable = true;
    x11.enable = true;
  };

  home.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    WLR_RENDERER = "vulkan";
    MOZ_ENABLE_WAYLAND = "1";
  };

  home.packages = with pkgs; [
      swaybg
      swaylock
      grim
      slurp
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      exec-once = [
        "swaybg --mode fill --image ~/Pictures/Wallpapers/eclipse.png"
        "waybar"
      ];
      input = {
        kb_variant = "colemak_dh";
        accel_profile = "flat";
      };
      bind = [
        "$mod, Return, exec, kitty"
        "$mod, R, exec, wofi --show drun"
        "$mod, H, movefocus, l"
        "$mod, J, movefocus, d"
        "$mod, K, movefocus, u"
        "$mod, L, movefocus, r"
        "$mod SHIFT, E, exit"
        "$mod, E, exec, dolphin"
        "$mod , SPACE, togglefloating"
        "$mod, Print, exec, grim - | wl-copy"
        "$mod SHIFT, Print, exec, grim -g $(slurp) - | wl-copy"
      ] ++ (
        # workspaces
        # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
        builtins.concatLists (builtins.genList (
            x: let
              ws = let
                c = (x + 1) / 10;
              in
                builtins.toString (x + 1 - (c * 10));
            in [
              "$mod, ${ws}, workspace, ${toString (x + 1)}"
              "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
            ]
          )
          10)
      );
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
        "$mod ALT, mouse:272, resizewindow"
      ];
      decoration = {
          rounding = 10;
      };
      animation = [
        "workspaces,1,3,default"
        "windows,1,3,default"
      ];
    };
  };

  programs.waybar = {
    enable = true;
    settings = { 
      mainBar = {
        modules-left = ["hyprland/workspaces"];
        modules-center = ["hyprland/window"];
        modules-right = ["clock"];
        layer = "top";
        position = "top";
      };
    };
  };
}
