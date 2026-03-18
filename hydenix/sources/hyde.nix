{ pkgs, inputs }:
pkgs.stdenv.mkDerivation {
  name = "hyde-modified";
  src = inputs.hyde;

  nativeBuildInputs = with pkgs; [
    gnutar
    unzip
  ];

  buildPhase = ''
    # remove assets folder
    rm -rf Source/assets

    rm -rf Configs/.local/lib/hyde/resetxdgportal.sh
    rm -rf Configs/.local/bin/hydectl
    rm -rf Configs/.local/bin/hyde-ipc
    rm -rf Configs/.local/lib/hyde/hyde-config
    rm -rf Configs/.local/lib/hyde/hyq
    rm -rf Configs/.local/bin/hyq

    # Remove Nix-irrelevant files (package manager wrappers, system update scripts)
    rm -rf Configs/.local/lib/hyde/pm.py
    rm -rf Configs/.local/lib/hyde/pm
    rm -rf Configs/.local/lib/hyde/system.update.sh

    # Update waybar killall command in all HyDE files
    find . -type f -print0 | xargs -0 sed -i 's/killall waybar/killall .waybar-wrapped/g'

    # update dunst
    find . -type f -print0 | xargs -0 sed -i 's/killall dunst/killall .dunst-wrapped/g'

    # update kitty
    find . -type f -print0 | xargs -0 sed -i 's/killall kitty/killall .kitty-wrapped/g'
    find . -type f -print0 | xargs -0 sed -i 's/killall -SIGUSR1 kitty/killall -SIGUSR1 .kitty-wrapped/g'

    # fix find commands for symlinks
    find . -type f -executable -print0 | xargs -0 sed -i 's/find "/find -L "/g'
    find . -type f -name "*.sh" -print0 | xargs -0 sed -i 's/find "/find -L "/g'

    # remove pkill command from rofilaunch.sh (line 2: "pkill rofi && exit 0")
    sed -i '2d' Configs/.local/lib/hyde/rofilaunch.sh

    # Fix lockscreen.sh: exec the lockscreen command directly instead of
    # wrapping it in a transient systemd service via app2unit.sh.
    # The original creates a oneshot service that exits immediately while
    # hyprlock.sh spawns hyprlock in a separate scope — the lock never appears.
    sed -i '/^unit_name=/,$ { s|app2unit.sh.*-- "\$lockscreen.sh" "\$@"|exec "\$lockscreen.sh" "\$@"| ; s|app2unit.sh.*-- "\$lockscreen" "\$@"|exec "\$lockscreen" "\$@"| }' Configs/.local/lib/hyde/lockscreen.sh

    # Remove broken waybar layout 02 (renders empty bar)
    rm -f Configs/.config/waybar/layouts/hyprdots/02.jsonc
    rm -f Configs/.local/share/waybar/layouts/hyprdots/02.jsonc

    # BUILD FONTS
    mkdir -p $out/share/fonts/truetype
    for fontarchive in ./Source/arcs/Font_*.tar.gz; do
      if [ -f "$fontarchive" ]; then
        tar xzf "$fontarchive" -C $out/share/fonts/truetype/
      fi
    done

    # BUILD VSCODE EXTENSION
    mkdir -p $out/share/vscode/extensions/prasanthrangan.wallbash
    unzip ./Source/arcs/Code_Wallbash.vsix -d $out/share/vscode/extensions/prasanthrangan.wallbash
    # Ensure extension is readable and executable
    chmod -R a+rX $out/share/vscode/extensions/prasanthrangan.wallbash

    # BUILD GRUB THEMES
    mkdir -p $out/share/grub/themes
    tar xzf ./Source/arcs/Grub_Retroboot.tar.gz -C $out/share/grub/themes
    tar xzf ./Source/arcs/Grub_Pochita.tar.gz -C $out/share/grub/themes

    # BUILD ICONS
    mkdir -p $out/share/icons
    tar xzf ./Source/arcs/Icon_Wallbash.tar.gz -C $out/share/icons

    # BUILD GTK THEME
    mkdir -p $out/share/themes
    tar xzf ./Source/arcs/Gtk_Wallbash.tar.gz -C $out/share/themes
  '';

  installPhase = ''
    mkdir -p $out
    cp -r . $out
  '';
}
