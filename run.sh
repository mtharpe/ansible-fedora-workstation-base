#!/bin/bash
ansible=`which ansible`

if [ -z "$ansible" ]; then
 sudo dnf install ansible -y
fi

if [ ! -f "/etc/sudoers/${USER}" ]; then
  echo "${USER} ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/${USER}
fi

if [ -z "$ansible" ]; then
 sudo dnf install ansible -y
fi

ansible-playbook setup_workstation.yml --extra-vars "local_user=${USER} local_user_email=${USER}@gmail.com"

sudo rm -f /etc/sudoers.d/${USER}

