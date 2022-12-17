# Ansible Collection for DAOS

Ansible Collection for DAOS

**Warning!** This repo is experimental and should not be used for production.

**Table of Contents**

- [Features](#features)
- [Versions](#minimal-tested-versions)
- [Prerequisites](#prerequisites)
- [Installation Instructions](#installation-instructions)
- [Optional Role Variables](#optional-role-variables)
- [Available Roles](#available-roles)
- [Cluster Membership](#cluster-membership)
- [Limitations](#limitations)
- [Troubleshooting](#troubleshooting)
- [Reporting Issues and Feedback](#reporting-issues-and-feedback)
- [Contributing Code](#contributing-code)
- [Disclaimer](#disclaimer)
- [Copyright and License](#copyright-and-license)

## Features

#### Inventory
- [x] Pre-built infrastructure (use static inventory file and group_vars directory)
- [ ] Dynamic inventory

#### Install DAOS Version

- [ ] DAOS v1.2
- [x] DAOS v2.0
- [x] DAOS v2.2

#### OS support

Deploy DAOS on

- [x] EL8 (Rocky Linux, AlmaLinux, RHEL 8) on x86_64
- [x] EL9 (Rocky Linux, AlmaLinux, RHEL 9) on x86_64
- [x] openSUSE Leap 15.3 on x86_64
- [ ] openSUSE Leap 15.4 on x86_64
- [ ] Debian
- [ ] Ubuntu

#### Run as

- [x] Root
- [ ] User with sudo

#### Prerequisites

In order to use this Ansible collection
- [x] Passwordless SSH as root from Ansible control host
- [x] All hosts have port 443 open to github.com and packages.daos.io
- [ ] Install and start NTP
- [ ] Create /etc/hosts mappings
- [ ] Open firewall ports
- [x] Generate SSH key
- [x] User must set up base OS repositories
