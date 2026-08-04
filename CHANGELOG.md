# Changelog

## Unreleased
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

