{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.hydenix.hm.hyprland;
in
{
  imports = [
    ./options.nix
    ./assertions.nix
    ./animations.nix
    ./shaders.nix
    ./workflows.nix
    ./hypridle.nix
    ./keybindings.nix
    ./windowrules.nix
    ./nvidia.nix
    ./monitors.nix
  ];

  config = lib.mkIf cfg.enable {
    # Always include packages and base setup
    home.packages = [
      pkgs.hyprutils
      pkgs.hyprpicker
      pkgs.hyprcursor
    ];

    home.activation.createHyprConfigs = lib.hm.dag.entryAfter [ "mutableGeneration" ] ''
      mkdir -p "$HOME/.config/hypr/animations"
      mkdir -p "$HOME/.config/hypr/themes"
      mkdir -p "$HOME/.config/hypr/shaders"
      mkdir -p "$HOME/.config/hypr/workflows"

      touch "$HOME/.config/hypr/animations/theme.conf"
      touch "$HOME/.config/hypr/themes/colors.conf"
      touch "$HOME/.config/hypr/themes/theme.conf"
      touch "$HOME/.config/hypr/themes/wallbash.conf"

      chmod 644 "$HOME/.config/hypr/animations/theme.conf"
      chmod 644 "$HOME/.config/hypr/themes/colors.conf"
      chmod 644 "$HOME/.config/hypr/themes/theme.conf"
      chmod 644 "$HOME/.config/hypr/themes/wallbash.conf"

    '';

    home.file = {
      # Deploy .local/share/hypr/ files individually so windowrules.conf
      # can be managed separately with its own override mechanism
      ".local/share/hypr/defaults.conf" = {
        source = "${pkgs.hyde}/Configs/.local/share/hypr/defaults.conf";
        force = true;
      };
      ".local/share/hypr/dynamic.conf" = {
        source = "${pkgs.hyde}/Configs/.local/share/hypr/dynamic.conf";
        force = true;
      };
      ".local/share/hypr/env.conf" = {
        source = "${pkgs.hyde}/Configs/.local/share/hypr/env.conf";
        force = true;
      };
      ".local/share/hypr/finale.conf" = {
        source = "${pkgs.hyde}/Configs/.local/share/hypr/finale.conf";
        force = true;
      };
      ".local/share/hypr/hyprland.conf" = {
        source = "${pkgs.hyde}/Configs/.local/share/hypr/hyprland.conf";
        force = true;
      };
      ".local/share/hypr/startup.conf" = {
        source = "${pkgs.hyde}/Configs/.local/share/hypr/startup.conf";
        force = true;
      };
      ".local/share/hypr/variables.conf" = {
        source = "${pkgs.hyde}/Configs/.local/share/hypr/variables.conf";
        force = true;
      };
      # windowrules.conf is managed by windowrules.nix
      ".config/hypr/hyprland.conf" =
        if cfg.overrideMain != null then
          {
            text = cfg.overrideMain;
            force = true;
          }
        else
          {
            source = "${pkgs.hyde}/Configs/.config/hypr/hyprland.conf";
            force = true;
          };

      ".config/hypr/userprefs.conf" = {
        text = cfg.extraConfig;
        force = true;
      };
    };
  };
}
