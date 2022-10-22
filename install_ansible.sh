#!/bin/bash
# Copyright 2022 Intel Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# This script will ensure that Ansible is installed.
#
#!/bin/bash

ACD_VENV_DIR="${ACD_VENV_DIR:-/usr/local/ansible-collection-daos/venv}"

# BEGIN: Logging variables and functions
declare -A LOG_LEVELS=([DEBUG]=0 [INFO]=1  [WARN]=2   [ERROR]=3 [FATAL]=4 [OFF]=5)
declare -A LOG_COLORS=([DEBUG]=2 [INFO]=12 [WARN]=148 [ERROR]=9 [FATAL]=9 [OFF]=0)
LOG_LEVEL=INFO

log() {
  local msg="$1"
  local lvl=${2:-INFO}
  if [[ ${LOG_LEVELS[$LOG_LEVEL]} -le ${LOG_LEVELS[$lvl]} ]]; then
    if [[ -t 1 ]]; then tput setaf ${LOG_COLORS[$lvl]}; fi
    printf "[%-5s] %s\n" "$lvl" "${msg}" 1>&2
    if [[ -t 1 ]]; then tput sgr0; fi
  fi
}

log.debug() { log "${1}" "DEBUG" ; }
log.info()  { log "${1}" "INFO"  ; }
log.warn()  { log "${1}" "WARN"  ; }
log.error() { log "${1}" "ERROR" ; }
log.fatal() { log "${1}" "FATAL" ; }
# END: Logging variables and functions

source /etc/os-release

declare -A pkg_mgr;
pkg_mgr[almalinux]=dnf
pkg_mgr[amzn]=yum
pkg_mgr[centos]=yum
pkg_mgr[debian]=apt-get
pkg_mgr[fedora]=dnf
pkg_mgr[opensuse-leap]=zypper
pkg_mgr[rhel]=dnf
pkg_mgr[rocky]=dnf
pkg_mgr[ubuntu]=apt-get

declare -A pkgs;
pkgs[almalinux]="curl wget git python39"
pkgs[amzn]="curl wget git python3 python3-pip"
pkgs[centos]="curl wget git python3 python3-pip"
pkgs[debian]="curl wget git python3 python3-pip"
pkgs[fedora]="curl wget git python3 python3-pip"
pkgs[opensuse-leap]="curl wget git python3 python3-pip"
pkgs[rhel]="curl wget git python39"
pkgs[rocky]="curl wget git python39"
pkgs[ubuntu]="curl wget git python3 python3-pip"

install_pkgs() {
  log.info "Installing packages"
  "${pkg_mgr[$ID]}" update
  if [[ "${pkg_mgr[$ID]}" == "apt" ]]; then
    "${pkg_mgr[$ID]}" -y upgrade
  fi
  "${pkg_mgr[$ID]}" install -y ${pkgs[$ID]}
}

activate_venv() {
  if [[ -z $VIRTUAL_ENV ]]; then
    source "${ACD_VENV_DIR}/bin/activate"
  fi
}

create_venv() {
  log.info "Creating python virtualenv in ${ACD_VENV_DIR}"
  mkdir -p "${ACD_VENV_DIR}"
  python3 -m venv "${ACD_VENV_DIR}"
  activate_venv
  log.info "Upgrading pip"
  pip install --upgrade pip
  deactivate
}

install_ansible() {
  log.info "Installing Ansible"
  activate_venv
  pip install ansible
}

show_versions() {
  activate_venv
  log.info "Python version"
  python3 --version
  log.info "Pip version"
  pip3 --version
  log.info "Ansible version"
  ansible --version
}

main() {
  if [[ ! -d "${ACD_VENV_DIR}" ]]; then
    install_pkgs
    create_venv
    install_ansible
  fi
  show_versions
}

main
