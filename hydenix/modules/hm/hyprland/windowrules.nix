{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.hydenix.hm.hyprland;

  # Hyprland v3 window rules for ~/.config/hypr/windowrules.conf
  configWindowrules = ''
    # █░█░█ █ █▄░█ █▀▄ █▀█ █░█░█   █▀█ █░█ █░░ █▀▀ █▀
    # ▀▄▀▄▀ █ █░▀█ █▄▀ █▄█ ▀▄▀▄▀   █▀▄ █▄█ █▄▄ ██▄ ▄█

    # See https://wiki.hypr.land/Configuring/Window-Rules/

    # '$&' is a hyde specific shorthand for "override"
    $&=override

    # idleinhibit rules
    windowrule = idleinhibit fullscreen, match:class ^(.*celluloid.*)$|^(.*mpv.*)$|^(.*vlc.*)$
    windowrule = idleinhibit fullscreen, match:class ^(.*[Ss]potify.*)$
    windowrule = idleinhibit fullscreen, match:class ^(.*LibreWolf.*)$|^(.*floorp.*)$|^(.*brave-browser.*)$|^(.*firefox.*)$|^(.*chromium.*)$|^(.*zen.*)$|^(.*vivaldi.*)$

    # Picture-in-Picture
    windowrule = tag +picture-in-picture, match:title ^([Pp]icture[-\s]?[Ii]n[-\s]?[Pp]icture)(.*)$
    windowrule = float true, match:tag picture-in-picture
    windowrule = keep_aspect_ratio true, match:tag picture-in-picture
    windowrule = move 73% 72%, match:tag picture-in-picture
    windowrule = size 25%, match:tag picture-in-picture
    windowrule = pin true, match:tag picture-in-picture

    windowrule = opacity 0.90 $& 0.90 $& 1, match:class ^(firefox)$
    windowrule = opacity 0.90 $& 0.90 $& 1, match:class ^(brave-browser)$
    windowrule = opacity 0.80 $& 0.80 $& 1, match:class ^(code-oss)$
    windowrule = opacity 0.80 $& 0.80 $& 1, match:class ^([Cc]ode)$
    windowrule = opacity 0.80 $& 0.80 $& 1, match:class ^(code-url-handler)$
    windowrule = opacity 0.80 $& 0.80 $& 1, match:class ^(code-insiders-url-handler)$
    windowrule = opacity 0.80 $& 0.80 $& 1, match:class ^(kitty)$
    windowrule = opacity 0.80 $& 0.80 $& 1, match:class ^(org.kde.dolphin)$
    windowrule = opacity 0.80 $& 0.80 $& 1, match:class ^(org.kde.ark)$
    windowrule = opacity 0.80 $& 0.80 $& 1, match:class ^(nwg-look)$
    windowrule = opacity 0.80 $& 0.80 $& 1, match:class ^(qt5ct)$
    windowrule = opacity 0.80 $& 0.80 $& 1, match:class ^(qt6ct)$
    windowrule = opacity 0.80 $& 0.80 $& 1, match:class ^(kvantummanager)$
    windowrule = opacity 0.80 $& 0.70 $& 1, match:class ^(org.pulseaudio.pavucontrol)$
    windowrule = opacity 0.80 $& 0.70 $& 1, match:class ^(blueman-manager)$
    windowrule = opacity 0.80 $& 0.70 $& 1, match:class ^(nm-applet)$
    windowrule = opacity 0.80 $& 0.70 $& 1, match:class ^(nm-connection-editor)$
    windowrule = opacity 0.80 $& 0.70 $& 1, match:class ^(org.kde.polkit-kde-authentication-agent-1)$
    windowrule = opacity 0.80 $& 0.70 $& 1, match:class ^(polkit-gnome-authentication-agent-1)$
    windowrule = opacity 0.80 $& 0.70 $& 1, match:class ^(org.freedesktop.impl.portal.desktop.gtk)$
    windowrule = opacity 0.80 $& 0.70 $& 1, match:class ^(org.freedesktop.impl.portal.desktop.hyprland)$
    windowrule = opacity 0.70 $& 0.70 $& 1, match:class ^([Ss]team)$
    windowrule = opacity 0.70 $& 0.70 $& 1, match:class ^(steamwebhelper)$
    windowrule = opacity 0.70 $& 0.70 $& 1, match:class ^([Ss]potify)$
    windowrule = opacity 0.70 $& 0.70 $& 1, match:initial_title ^(Spotify Free)$
    windowrule = opacity 0.70 $& 0.70 $& 1, match:initial_title ^(Spotify Premium)$

    windowrule = opacity 0.90 0.90, match:class ^(com.github.rafostar.Clapper)$
    windowrule = opacity 0.80 0.80, match:class ^(com.github.tchx84.Flatseal)$
    windowrule = opacity 0.80 0.80, match:class ^(hu.kramo.Cartridges)$
    windowrule = opacity 0.80 0.80, match:class ^(com.obsproject.Studio)$
    windowrule = opacity 0.80 0.80, match:class ^(gnome-boxes)$
    windowrule = opacity 0.80 0.80, match:class ^(vesktop)$
    windowrule = opacity 0.80 0.80, match:class ^(discord)$
    windowrule = opacity 0.80 0.80, match:class ^(WebCord)$
    windowrule = opacity 0.80 0.80, match:class ^(ArmCord)$
    windowrule = opacity 0.80 0.80, match:class ^(app.drey.Warp)$
    windowrule = opacity 0.80 0.80, match:class ^(net.davidotek.pupgui2)$
    windowrule = opacity 0.80 0.80, match:class ^(yad)$
    windowrule = opacity 0.80 0.80, match:class ^(Signal)$
    windowrule = opacity 0.80 0.80, match:class ^(io.github.alainm23.planify)$
    windowrule = opacity 0.80 0.80, match:class ^(io.gitlab.theevilskeleton.Upscaler)$
    windowrule = opacity 0.80 0.80, match:class ^(com.github.unrud.VideoDownloader)$
    windowrule = opacity 0.80 0.80, match:class ^(io.gitlab.adhami3310.Impression)$
    windowrule = opacity 0.80 0.80, match:class ^(io.missioncenter.MissionCenter)$
    windowrule = opacity 0.80 0.80, match:class ^(io.github.flattool.Warehouse)$

    windowrule = float true, match:class ^(Signal)$
    windowrule = float true, match:class ^(com.github.rafostar.Clapper)$
    windowrule = float true, match:class ^(app.drey.Warp)$
    windowrule = float true, match:class ^(net.davidotek.pupgui2)$
    windowrule = float true, match:class ^(yad)$
    windowrule = float true, match:class ^(eog)$
    windowrule = float true, match:class ^(io.github.alainm23.planify)$
    windowrule = float true, match:class ^(io.gitlab.theevilskeleton.Upscaler)$
    windowrule = float true, match:class ^(com.github.unrud.VideoDownloader)$
    windowrule = float true, match:class ^(io.gitlab.adhami3310.Impression)$
    windowrule = float true, match:class ^(io.missioncenter.MissionCenter)$

    # workaround for jetbrains IDEs dropdowns/popups cause flickering
    windowrule = no_initial_focus true, match:class ^(.*jetbrains.*)$, match:title ^(win[0-9]+)$

    # █░░ ▄▀█ █▄█ █▀▀ █▀█   █▀█ █░█ █░░ █▀▀ █▀
    # █▄▄ █▀█ ░█░ ██▄ █▀▄   █▀▄ █▄█ █▄▄ ██▄ ▄█

    layerrule = blur true, match:namespace rofi
    layerrule = ignore_alpha 0, match:namespace rofi
    layerrule = blur true, match:namespace notifications
    layerrule = ignore_alpha 0, match:namespace notifications
    layerrule = blur true, match:namespace swaync-notification-window
    layerrule = ignore_alpha 0, match:namespace swaync-notification-window
    layerrule = blur true, match:namespace swaync-control-center
    layerrule = ignore_alpha 0, match:namespace swaync-control-center
    layerrule = blur true, match:namespace logout_dialog
  '';

  # Hyprland v3 window rules for ~/.local/share/hypr/windowrules.conf
  shareWindowrules = ''
    #? Rules can be added here as most of the configuration are dynamic

    # // █░█░█ █ █▄░█ █▀▄ █▀█ █░█░█   █▀█ █░█ █░░ █▀▀ █▀
    # // ▀▄▀▄▀ █ █░▀█ █▄▀ █▄█ ▀▄▀▄▀   █▀▄ █▄█ █▄▄ ██▄ ▄█

    # See https://wiki.hypr.land/Configuring/Window-Rules/

    # Sizes for floating popups
    windowrule = size <85% <95%, match:float true
    windowrule = float true, match:tag common-popups
    windowrule = size <60% <90%, match:tag common-popups

    # Fix file chooser dialogs opening off-screen
    windowrule = float true, match:tag portal-dialogs
    windowrule = center true, match:tag portal-dialogs

    # Only add the Core applications here
    windowrule = float true, match:class ^(com.gabm.satty)$
    windowrule = float true, match:class ^(org.kde.dolphin)$, match:title ^(Progress Dialog — Dolphin)$
    windowrule = float true, match:class ^(org.kde.dolphin)$, match:title ^(Copying — Dolphin)$
    windowrule = float true, match:title ^(About Mozilla Firefox)$
    windowrule = float true, match:class ^(.*)$, match:initial_title ^(top)$
    windowrule = float true, match:class ^(.*)$, match:initial_title ^(btop)$
    windowrule = float true, match:class ^(.*)$, match:initial_title ^(htop)$
    windowrule = float true, match:class ^(vlc)$
    windowrule = float true, match:class ^(kvantummanager)$
    windowrule = float true, match:class ^(qt5ct)$
    windowrule = float true, match:class ^(qt6ct)$
    windowrule = float true, match:class ^(nwg-look)$
    windowrule = float true, match:class ^(nwg-displays)$
    windowrule = float true, match:class ^(org.kde.ark)$
    windowrule = float true, match:class ^(org.pulseaudio.pavucontrol)$
    windowrule = float true, match:class ^(blueman-manager)$
    windowrule = float true, match:class ^(nm-applet)$
    windowrule = float true, match:class ^(nm-connection-editor)$
    windowrule = float true, match:class ^(org.kde.polkit-kde-authentication-agent-1)$

    # common popups
    windowrule = tag +common-popups, match:initial_title ^(Open File)$
    windowrule = tag +common-popups, match:title ^(Choose Files)$
    windowrule = tag +common-popups, match:title ^(Save As)$
    windowrule = tag +common-popups, match:title ^(Confirm to replace files)$
    windowrule = tag +common-popups, match:title ^(File Operation Progress)$
    windowrule = tag +common-popups, match:class ^([Xx]dg-desktop-portal-gtk)$
    windowrule = tag +common-popups, match:title ^(Open)$
    windowrule = tag +common-popups, match:title ^(Authentication Required)$
    windowrule = tag +common-popups, match:title ^(Add Folder to Workspace)$
    windowrule = tag +common-popups, match:title ^(File Upload)(.*)$
    windowrule = tag +common-popups, match:title ^(Choose wallpaper)(.*)$
    windowrule = tag +common-popups, match:title ^(Library)(.*)$
    windowrule = tag +common-popups, match:class ^(.*dialog.*)$
    windowrule = tag +common-popups, match:title ^(.*dialog.*)$

    # portal-dialogs
    windowrule = tag +portal-dialogs, match:class ^(org.freedesktop.impl.portal.desktop.hyprland)$
    windowrule = tag +portal-dialogs, match:class ^(org.freedesktop.impl.portal.desktop.gtk)$
    windowrule = tag +portal-dialogs, match:class ^([Xx]dg-desktop-portal-gtk)$

    # // █░░ ▄▀█ █▄█ █▀▀ █▀█   █▀█ █░█ █░░ █▀▀ █▀
    # // █▄▄ █▀█ ░█░ ██▄ █▀▄   █▀▄ █▄█ █▄▄ ██▄ ▄█

    layerrule = blur true, match:namespace rofi
    layerrule = ignore_alpha 0, match:namespace rofi
    layerrule = blur true, match:namespace notifications
    layerrule = ignore_alpha 0, match:namespace notifications
    layerrule = blur true, match:namespace swaync-notification-window
    layerrule = ignore_alpha 0, match:namespace swaync-notification-window
    layerrule = blur true, match:namespace swaync-control-center
    layerrule = ignore_alpha 0, match:namespace swaync-control-center
    layerrule = blur true, match:namespace logout_dialog
    layerrule = ignore_alpha 0, match:namespace logout_dialog
    layerrule = blur true, match:namespace waybar
    layerrule = ignore_alpha 0, match:namespace waybar
  '';
in
{
  config = lib.mkIf (cfg.enable && cfg.windowrules.enable) {
    home.file = {
      ".config/hypr/windowrules.conf" =
        if cfg.windowrules.overrideConfig != null then
          {
            text = cfg.windowrules.overrideConfig;
            force = true;
          }
        else
          {
            text = ''
              ${configWindowrules}
              ${cfg.windowrules.extraConfig}
            '';
            force = true;
          };

      ".local/share/hypr/windowrules.conf" = {
        text = shareWindowrules;
        force = true;
      };
    };
  };
}
