# Changelog

## Unreleased
- Close the gap between the icon theme this repo provisions and the one
  actually on the workstation. Three icons had been added to
  `~/.local/share/icons` by hand and existed nowhere in the repo, so a fresh
  provision would have left Messages and Messenger showing the un-themed
  hicolor PNGs their build script drops (theme lookup runs before hicolor, so
  a name Colloid can't resolve is what puts one un-themed tile in a row of
  themed ones). Adds the hand-drawn `google-messages.svg` and `tidal.svg` to
  `colloid_extra_icons`, and introduces `colloid_icon_aliases` for names the
  theme does not otherwise answer to — `messenger.svg` is symlinked to
  upstream's `fbmessenger.svg` rather than vendored, so it keeps tracking
  upstream if the artwork is restyled
- Draw a Colloid-style Cider icon, so Apple Music stops being the one
  un-themed tile in the dock. Cider is a flatpak and its desktop entry asks
  for `sh.cider.Cider`, which Colloid has nothing for, so this adds
  `cider.svg` to `colloid_extra_icons` plus an `sh.cider.Cider` alias onto it
  — the same two-name pattern Colloid itself uses for `gmail.svg`. The glyph
  is scaled from the geometry in Cider's own `cider-outline.svg` rather than
  redrawn by eye; the tile is flat, matching Colloid's other brand tiles
  (`spotify.svg`, `discord.svg`), using the midpoint of Cider's
  crimson-to-magenta gradient
- Make `electron_apps_slugs` authoritative for what build-linux.sh builds,
  not just for the "already built?" idempotency check. The build task now
  passes the slugs to build-linux.sh explicitly instead of letting its
  default ("everything in services.conf") apply, so a service being added
  upstream no longer implicitly ships. Drops `tidal` from the default slug
  list — Apple Music (Cider) covers the same audience without the Widevine
  build machinery. Existing tidal installs are left in place; use
  `build-linux.sh --uninstall tidal` to remove
- Add Cider (Apple Music client) as a third-party app, gated by
  `install_cider`. Upstream ships no Fedora RPM repo, so the task installs
  the `sh.cider.Cider` flatpak from Flathub — first ensuring the flathub
  remote is present system-wide, so a fresh machine gets both without
  manual setup
- Repurpose `Shift+Alt+4` from area-to-clipboard to area-to-Satty. The new
  `area-screenshot-annotate` helper captures via the xdg-desktop-portal
  Screenshot interface (same path the clipboard helpers use — the only
  sanctioned capture on GNOME 50) then pipes the PNG into Satty so arrows,
  highlights, text, and blur can be added before saving. Save destination is
  `~/Pictures/Screenshots/satty-<timestamp>.png`; Satty's copy hook is wired to
  `wl-copy` and it exits after Save or Copy. Satty is not carried on the org's
  filtered Flathub view, so `keybindings.yml` installs the upstream x86_64
  tarball to `/usr/local/bin/satty`, pinned to `satty_version` /
  `satty_sha256` in `vars/vars.yml`. `Shift+Alt+3` (fullscreen to clipboard)
  is unchanged
- Rename the `google_apps_*` variables, task file, tags, and local checkout dir
  to `electron_apps_*` / `electron-apps.yml` / `~/.local/src/electron-apps`.
  Upstream `linux-google-apps` was renamed to `electron-apps` after it grew
  wrappers for Tidal and Messenger — a Google-only name no longer described
  what the role installs. Existing systems get a one-shot `mv` migration of
  the legacy checkout dir and revision-stamp file, so the recorded build state
  survives and no unnecessary rebuild fires. Adds `google-messages`, `tidal`,
  and `messenger` to `electron_apps_slugs` so the per-slug "already built?"
  check matches the full services.conf
- Fix Qt and Electron apps rendering light window decorations under a dark
  GNOME session. `QT_QPA_PLATFORMTHEME` was `gnome`, which selected
  qgnomeplatform — dropped from Fedora after 43, so it silently degraded to
  Qt's built-in light-only fallback theme. It is now `gtk3` (libqgtk3, still
  shipped for Qt5 and Qt6), which derives the Qt palette from the active GTK3
  theme. Adds `QT_WAYLAND_DECORATION=adwaita` so Qt's client-side Wayland
  titlebars use the portal-following Adwaita decoration instead of the
  always-light `bradient` default, and `ELECTRON_OZONE_PLATFORM_HINT=auto` so
  Electron apps run natively on Wayland rather than drawing their own light
  XWayland titlebar
- Write the dark-mode environment to `~/.config/environment.d/90-dark-mode.conf`
  in addition to `/etc/environment`: PAM covers login, but `systemd --user` is
  what actually launches apps from the Shell and does not inherit it
- Probe for and install `qadwaitadecorations-qt{5,6}` /
  `qt6-qtwayland-adwaita-decoration`, and move the probe list and the
  environment into `gnome_darkmode_candidate_pkgs` / `gnome_darkmode_env`
- Set `gtk-theme-name` in `~/.config/gtk-4.0/settings.ini`;
  `gtk-application-prefer-dark-theme` alone is a GTK3-only key and does nothing
  for GTK4
- Launch Chrome with `--force-dark-mode` so its self-drawn Wayland titlebar does
  not depend on the per-profile theme toggle in `chrome://settings/appearance`
- Fix duplicate dock icons for Alacritty and Chrome: a user-level `.desktop` only
  overrides the system one when its desktop ID matches exactly, so the Alacritty
  override is now written under the filename the distro actually ships (probed,
  not hardcoded), and Chrome's `com.google.Chrome.desktop` twin — which claimed
  the same `StartupWMClass` — is shadowed
- Add the missing `StartupWMClass=google-chrome` to the Chrome override
- Override `slack.desktop` to replace its hardcoded absolute `Icon=` path with a
  themeable icon name, so icon themes can restyle Slack
- Install the Colloid icon theme per-user and select it via dconf
  (`install_colloid_icons`, `gnome_icon_theme`), including hand-drawn Google Keep
  and Tasks icons that upstream does not ship
- Build and install the standalone Google web apps (Gmail, Calendar, Tasks, Keep)
  from `linux-google-apps` (`install_google_apps`)
- Install `podman-docker` alongside Podman when `install_docker` is off, and
  create `/etc/containers/nodocker` to silence its per-invocation emulation notice
- Stop terminal applications raising desktop notifications: set Claude Code's
  `preferredNotifChannel` to `notifications_disabled` (merged into an existing
  `settings.json` rather than rewriting it), and block GNOME notifications for
  the terminal desktop IDs via `gnome_notification_blocked_apps`
- Add an `install_twingate` toggle for the Twingate zero-trust client. Upstream
  publishes no GPG key for its RPM repo, so it is added with `gpgcheck` disabled,
  matching Twingate's own installer
- Align user-home file ownership between the Chrome and Alacritty tasks, which
  previously fought over the group on `~/.local/share/applications` and rewrote
  the desktop entries on every run
- Add Fedora 43 support (pin Molecule image to `fedora:43`)
- Introduce `fedora_version` variable in `vars/vars.yml` for easier future bumps
- Update README to state Fedora 43+
- Remove OwnCloud role, variables, and templates (deprecated / not required)

