git clone https://github.com/mtharpe/ansible-fedora-workstation-base.git

[![CircleCI](https://circleci.com/gh/mtharpe/ansible-fedora-workstation-base/tree/main.svg?style=svg)](https://circleci.com/gh/mtharpe/ansible-fedora-workstation-base/tree/main)

# Fedora Workstation Base

Ansible playbook and role collection to automate the setup of a Fedora 42+ workstation for development and daily use.

## Features

- Installs and configures essential packages, fonts, and developer tools
- Sets up user shell environments (Bash, Fish)
- Configures system security (sshd, fail2ban)
- Adds third-party repositories (HashiCorp, RPM Fusion, 1Password)
- Customizes GNOME and other desktop settings

## Directory Structure

- `setup_workstation.yml` — Main playbook
- `roles/common/tasks/` — Core tasks (packages, users, services, system, harden, bash, fish)
- `roles/gnome/` — GNOME desktop customizations
- `roles/third-party/` — Third-party apps and tools
- `templates/` — Config files and templates for shells, tmux, etc.
- `vars/vars.yml` — Main variable file for customization

## Quick Start

1. **Clone the repository:**
	```sh
	git clone https://github.com/mtharpe/ansible-fedora-workstation-base.git
	cd ansible-fedora-workstation-base
	```

2. **Review and edit variables:**
	- Edit `vars/vars.yml` to set your username, enable/disable features, and customize package lists.

3. **Run the playbook:**
	```sh
	./run.sh
	```
	This script will invoke Ansible with the correct inventory and configuration.

## Customization

- Enable or disable features (e.g., Bash, Fish, Harden, GNOME) by setting variables in `vars/vars.yml`.
- Add or remove packages in `roles/common/tasks/packages.yml`.
- Adjust system settings in `roles/common/tasks/system.yml` and `roles/common/tasks/harden.yml`.
- Add your own templates or dotfiles in the `templates/` directory.

## Linting and Best Practices

This codebase follows [ansible-lint](https://ansible-lint.readthedocs.io/) best practices. To check for issues:

```sh
ansible-lint roles/common/tasks/*.yml
```

## Testing

Molecule is included for role testing. To run tests:

```sh
cd molecule/default
molecule test
```

## License

MIT License. See [LICENSE](LICENSE) for details.
