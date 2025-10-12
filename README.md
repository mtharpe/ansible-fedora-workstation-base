[![CircleCI](https://circleci.com/gh/mtharpe/ansible-fedora-workstation-base/tree/main.svg?style=svg)](https://circleci.com/gh/mtharpe/ansible-fedora-workstation-base/tree/main)

# Fedora Workstation Base

Ansible playbook and role collection to automate the setup of a Fedora 42+ workstation for development and daily use.

## What this repository contains

- An Ansible-based set of roles and playbooks to configure a Fedora workstation.
- Role layout:
  - `roles/common` — core packages, users, system-level settings, shells (bash/fish) and services.
  - `roles/gnome` — GNOME-specific settings (dconf, desktop tweaks). These tasks are skipped when running inside containers.
  - `roles/third-party` — installers for third-party applications (Chrome, VS Code, Slack, etc.).
- Templates and dotfiles under `templates/`.
- Variables in `vars/vars.yml` to toggle features and customize packages.

> Note: The repository previously included a `molecule/libvirt` scenario for VM testing. That scenario has been removed; the maintained Molecule scenario is `molecule/default` (podman).

## Quick start

1. Clone the repository:

```sh
git clone https://github.com/mtharpe/ansible-fedora-workstation-base.git
cd ansible-fedora-workstation-base
```

2. Review and adjust variables in `vars/vars.yml`:

- Set `local_user` and feature flags (install_bash, install_fish, install_gnome, etc.).

3. Run the automated setup for your workstation (interactive script wrapper):

```sh
./run.sh
```

The `run.sh` script calls Ansible with the inventory and variables appropriate for a local Fedora workstation. Inspect it before running.

## Running tests with Molecule (podman)

This repository includes a Molecule scenario for container-based testing using the podman driver. The default scenario is found at `molecule/default`.

To run the full Molecule test (create/converge/idempotence/verify/destroy):

```sh
cd molecule/default
molecule test
```

If you only want to create and converge a single scenario:

```sh
molecule create -s default
molecule converge -s default
```

GNOME-related tasks are guarded and will be skipped when the test instance is a container (so the podman scenario stays fast and reliable).

## Customization

- Add/remove packages in `roles/common/tasks/packages.yml`.
- Tweak system settings in `roles/common/tasks/system.yml` and `roles/common/tasks/harden.yml`.
- Drop your own templates and dotfiles into `templates/` and update the roles to deploy them.

## Linting and best practices

You can lint Ansible roles with `ansible-lint`:

```sh
ansible-lint roles/common/tasks/*.yml
```

## Cleaning up artifacts

During prior testing, large QCOW2 images and temporary files may have been created on hosts used for VM testing. Those artifacts are not required for normal use and may be removed. Example locations that were used during earlier development (if present):

- `/home/<user>/.cache/molecule_images/`
- `/home/<user>/.local/molecule/libvirt/vms/`
- `/var/lib/libvirt/images/`

Remove them only if you are sure you don't need the images anymore.

## License

MIT License. See [LICENSE](LICENSE) for details.
