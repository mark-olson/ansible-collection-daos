# Ansible Collection for DAOS

Ansible Collection for DAOS

This collection is still in the **very** early stages of development and will
be undergoing many changes. This is collection is not recommended for production
deployments.

**Table of Contents**

- [Features](#features)
    - [Inventory](#inventory)
    - [Install DAOS Version](#install-daos-version)
    - [OS support](#os-support)
    - [Run as](#run-as)
    - [Prerequisites](#prerequisites)
- [Installation Instructions](#installation-instructions)
  - [Install on a DAOS admin node](#install-on-a-daos-admin-node)
  - [Install on a node where Ansible is already installed](#install-on-a-node-where-ansible-is-already-installed)
- [Inventory](#inventory-1)

## Features

#### Inventory
- [x] Pre-built infrastructure (use static inventory file and group_vars directory)
- [ ] Dynamic inventory

#### Install DAOS Version

- [ ] DAOS v1.2
- [ ] DAOS v2.0
- [x] DAOS v2.2

#### OS support

- [x] EL8 (Rocky Linux, AlmaLinux, RHEL 8) on x86_64
- [ ] EL9 (Rocky Linux, AlmaLinux, RHEL 9) on x86_64
- [ ] openSUSE Leap 15.3 on x86_64
- [ ] openSUSE Leap 15.4 on x86_64
- [ ] Debian
- [ ] Ubuntu

#### Run as

- [ ] Root
- [x] User named `ansible`.
  All target hosts must have an `ansible` user that has full sudo permissions without a password. The `/home/ansible/.ssh/authorized_keys` file on all target hosts must contain the public key of the the user who is running ansible commands on the control host.

#### Prerequisites

In order to use this Ansible collection

- [x] A current version of Python3 must be installed on all hosts.
      Python 3.9 or higher is preferred. At this time many distros
      default to Python 3.6 which will not be supported in future
      versions of Ansible.
- [x] Passwordless SSH as `ansible` user from Ansible control host must be configured on all hosts
- [x] `ansible` user must have full passwordless sudo permission on all hosts
- [x] All hosts have port 443 open to https://github.com and https://packages.daos.io
- [x] Time must be in sync on all target hosts. Use NTP or Chrony.
- [x] If DNS is not available, the /etc/hosts file on the Ansible controller must contain IPs and hostnames for all target hosts
- [x] Open firewall ports, 80, 443, 10001
- [x] You must have an SSH key pair to connect to the DAOS admin host (bastion).

## Installation Instructions

### Install on a DAOS admin node

If you plan to use this collection on a DAOS admin node (bastion) the [install_ansible.sh](install_ansible.sh) script in this repository can be used to install Ansible and set up a project directory.

The [install_ansible.sh](install_ansible.sh) script does the following:


- Install a current version of Python3
- Create a `~/ansible-daos` Ansible project directory
- Set up a Python3 virtual environment in `~/ansible-daos/.venv`
- Create `~/ansible-daos/group_vars` for inventory vars
- Create `~/ansible-daos/ansible.cfg`
- Install the daos-stack/daos collection

This is the recommended way to install Ansible on a DAOS Admin node.

To install Ansible on a DAOS Admin node, log on as the user who
will be running ansible commands and then run:

```bash
# Automatically create an inventory directory
export ANS_CREATE_INV_DIR=true

# Create an ansible.cfg file
export ANS_CREATE_CFG=true

curl -s https://raw.githubusercontent.com/daos-stack/ansible-collection-daos/main/in| bash -s
```

To run ansible commands you will need to

1. `change your working directory to `~/ansible-daos`
2. Activate the virtual environment

```bash
cd ~/ansible-daos
source .venv/bin/activate
```

After doing that you can run ansible commands from within the `~/ansible-daos` directory.  This is necessary because the `ansible.cfg` file that is in the directory is configured to run ansible as the `ansible` user with sudo when running tasks on remote hosts.


### Install on a node where Ansible is already installed

To install the collection on a node where Ansible is already installed run:

```bash
ansible-galaxy collection install "git+https://github.com/daos-stack/ansible-collection-daos.git"
```

To install the version on the develop branch run:

```bash
ansible-galaxy collection install "git+https://github.com/daos-stack/ansible-collection-daos.git,develop"
```

## Inventory

This collection requires that the following host groups are present in the inventory:

- daos_servers
- daos_clients
- daos_admins

If you installed Ansible using the [install_ansible.sh](install_ansible.sh) script as described above, a `~/ansible-daos/hosts` file will be created for you.

The file will be stubbed out and ready for you to add your hosts.

```
# file: ~/ansible-daos/hosts

[daos_admins]
localhost ansible_connection=local

[daos_clients]

[daos_servers]

[daos_cluster:children]
daos_admins
daos_clients
daos_servers
```

You will want to update this file with the names of your hosts. For example

```
# file: ~/ansible-daos/hosts

[daos_admins]
daos-admin-001 ansible_connection=local

[daos_clients]
daos-client-[001:016]

[daos_servers]
daos-server-001 is_access_point=true
daos-server-002 is_access_point=true
daos-server-003 is_access_point=true
daos-server-004
daos-server-005

[daos_cluster:children]
daos_admins
daos_clients
daos_servers
```
