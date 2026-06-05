#!/bin/bash
set -euo pipefail

if ! command -v pipx >/dev/null 2>&1; then
  # On RHEL-family distros (Rocky, etc.) pipx ships only in EPEL, which the
  # playbook enables later — too late for this bootstrap. Enable it here first.
  # Fedora carries pipx in its base repos, so this block is skipped there.
  . /etc/os-release
  if [ "${ID:-}" != "fedora" ] && printf '%s' "${ID:-} ${ID_LIKE:-}" | grep -qiE 'rhel|centos|rocky|almalinux'; then
    sudo dnf install -y epel-release
    sudo dnf config-manager --set-enabled crb
  fi
  sudo dnf install -y pipx
fi

export PATH="${HOME}/.local/bin:${PATH}"

if ! command -v ansible >/dev/null 2>&1; then
  pipx install --include-deps ansible
fi

if ! command -v ansible-lint >/dev/null 2>&1; then
  pipx install ansible-lint
fi

if ! command -v yamllint >/dev/null 2>&1; then
  pipx install yamllint
fi

if ! command -v molecule >/dev/null 2>&1; then
  pipx install --include-deps molecule
  pipx inject molecule 'molecule-plugins[docker]'
fi

SUDOERS_DROPIN="/etc/sudoers.d/${USER}"
if [ ! -f "${SUDOERS_DROPIN}" ]; then
  echo "${USER} ALL=(ALL) NOPASSWD: ALL" | sudo tee -a "${SUDOERS_DROPIN}"
fi

until ansible-playbook --extra-vars "local_user=${USER}" setup_workstation.yml; do
  echo "Ansible run disrupted, retrying in 10 seconds..."
  sleep 10
done

sudo rm -f "${SUDOERS_DROPIN}"
