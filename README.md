# appimage-util

Install and uninstall AppImages on Linux by double-clicking them. No icon hunting, no hand-written `.desktop` files.

## Install

```sh
git clone https://github.com/Aryan7901/appimage-util.git
cd appimage-util
./install.sh
```

This copies two scripts to `~/.local/bin` and adds two entries to your app grid. It also makes **AppImage Installer** the default app for `.AppImage` files.

Requirements: `python3`, `zenity`, `notify-send`, and `update-desktop-database` / `xdg-mime` (from `desktop-file-utils` and `xdg-utils`). GNOME and Fedora ship all of these.

To remove the tools later, run `./install.sh --remove`. Apps you installed with them stay installed.

## Installing an AppImage

Double-click a downloaded `.AppImage` (or right-click it and choose **Open With → AppImage Installer**). Confirm the name, and you're done.

Each app gets its own folder, with a launcher in your app grid:

```
~/AppImages/<app>/<file>.AppImage
~/AppImages/<app>/<app>.png|svg
~/.local/share/applications/appimage-<app>.desktop
```

- **Icon:** taken from inside the AppImage. It prefers a scalable SVG, then the largest PNG under `usr/share/icons/hicolor`, then the AppImage's top-level icon or `.DirIcon`. Only the icon and launcher files are unpacked, using the AppImage's own `--appimage-extract`. FUSE isn't needed.
- **Launcher details:** the name, category and `StartupWMClass` (so the open window groups with its dock icon) come from the app's own `.desktop` file. So do URL handlers such as `myapp://` links.
- **Updating:** double-click a newer version of an app you've already installed. It asks whether to replace the old file, and keeps the folder and launcher.
- **Already installed:** double-clicking an AppImage that's already in `~/AppImages` just runs it.

From a terminal: `appimage-install FILE.AppImage`, or run it with no arguments for a file picker.

## Uninstalling an app

Open **AppImage Uninstaller** from the app grid, or right-click an installed app's icon and choose **Uninstall**. It removes:

- **The app folder:** `~/AppImages/<app>/`.
- **Launchers:** every launcher that runs the app, including ones made by other tools (such as Pin It) or by the app itself, plus autostart entries.
- **Associations and dock:** the app's entries in `mimeapps.list`, and its pin on the GNOME dock.
- **Leftover data, after you review it:** folders in `~/.config`, `~/.local/share`, `~/.cache` and `~/.local/state`, plus icons the app installed itself. These are found by matching distinctive words from the app's name, so reverse-DNS folders such as `com.example.myapp` are caught. You get a checklist with sizes. Folders directly in your home folder (`~/.<name>`) start unticked, because they are often shared with a command-line install of the same tool.

The uninstaller offers to quit the app if it's still running.

From a terminal: `appimage-uninstall [NAME]`, or `appimage-uninstall --dry-run [NAME]` to print what would be removed without changing anything.

## Security note

Reading the icon and launcher means running the AppImage's built-in unpacker (`--appimage-extract`), which is code from the file itself. Only install AppImages you would be willing to run anyway.
