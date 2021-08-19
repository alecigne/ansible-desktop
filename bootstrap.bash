#!/bin/sh

set -eu

if ! command -v sudo >/dev/null 2>&1; then
	>&2 echo "This script requires 'sudo' binary to be installed"
	exit 1
fi

if [ "$(id -u)" -eq "0" ]; then
	>&2 echo "This script must be run as normal user"
	exit 1
fi

# Install necessary tools
sudo DEBIAN_FRONTEND=noninteractive apt-get update -qq
sudo apt-get install --no-install-recommends --no-install-suggests -y	git ansible

# Clone repository
mkdir ~/src && cd ~/src
git clone https://github.com/alecigne/ansible-desktop
cd ansible-desktop

# Use Ansible to switch from Debian stable to Debian testing
ansible-playbook playbook.yml -K -t dist-upgrade

# Use up-to-date Ansible to provision the system
ansible-playbook playbook.yml -K -t main
