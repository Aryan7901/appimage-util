#!/usr/bin/env bash
# Install appimage-install / appimage-uninstall for the current user.
#   ./install.sh           install (or update) and make it the .AppImage handler
#   ./install.sh --remove  remove the tools (apps you installed with them stay)
set -euo pipefail

BINDIR="${BINDIR:-$HOME/.local/bin}"
APPDIR="${XDG_DATA_HOME:-$HOME/.local/share}/applications"
SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MIME=(application/vnd.appimage application/x-iso9660-appimage)

if [[ "${1:-}" == "--remove" ]]; then
    rm -f "$BINDIR/appimage-install" "$BINDIR/appimage-uninstall" \
          "$APPDIR/appimage-installer.desktop" "$APPDIR/appimage-uninstaller.desktop"
    update-desktop-database "$APPDIR" 2>/dev/null || true
    echo "Removed. Apps in ~/AppImages and their launchers were left alone."
    exit 0
fi

for tool in python3 zenity notify-send update-desktop-database xdg-mime; do
    command -v "$tool" >/dev/null || echo "warning: '$tool' not found; install it for full functionality" >&2
done

mkdir -p "$BINDIR" "$APPDIR" "${XDG_CONFIG_HOME:-$HOME/.config}"
install -m 755 "$SRC/bin/appimage-install" "$SRC/bin/appimage-uninstall" "$BINDIR/"
for f in "$SRC"/applications/*.desktop.in; do
    sed "s#@BINDIR@#$BINDIR#g" "$f" > "$APPDIR/$(basename "${f%.in}")"
done
update-desktop-database "$APPDIR" 2>/dev/null || true
xdg-mime default appimage-installer.desktop "${MIME[@]}"

echo "Installed to $BINDIR. Double-click any .AppImage to install it."
case ":$PATH:" in *":$BINDIR:"*) ;; *) echo "note: $BINDIR is not on your PATH (only needed for terminal use)";; esac
