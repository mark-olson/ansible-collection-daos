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

ACD_VENV_DIR="${ACD_VENV_DIR:-/opt/ansible-collection-daos/venv}"

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

declare -A pkg_mgrs;
pkg_mgrs[almalinux]=dnf
pkg_mgrs[amzn]=yum
pkg_mgrs[centos]=yum
pkg_mgrs[debian]=apt-get
pkg_mgrs[fedora]=dnf
pkg_mgrs[opensuse-leap]=zypper
pkg_mgrs[rhel]=dnf
pkg_mgrs[rocky]=dnf
pkg_mgrs[ubuntu]=apt-get

pkg_mgr="${pkg_mgr[$ID]}"

declare -A pkg_list;
pkg_list[almalinux]="curl wget git python39"
pkg_list[amzn]="curl wget git python3 python3-pip"
pkg_list[centos]="curl wget git python3 python3-pip"
pkg_list[debian]="curl wget git python3 python3-pip"
pkg_list[fedora]="curl wget git python3 python3-pip"
pkg_list[opensuse-leap]="curl wget git python3 python3-pip"
pkg_list[rhel]="curl wget git python39"
pkg_list[rocky]="curl wget git python39"
pkg_list[ubuntu]="curl wget git python3 python3-pip"

pkgs="${pkg_list[$ID]}"

install_pkgs() {
  log.info "Installing packages"
  if [[ "${pkg_mgr}" == "apt" ]]; then
    log.info "Running ${pkg_mgr} update and upgrade"
    "${pkg_mgr}" update
    "${pkg_mgr}" -y upgrade
  else
    log.info "Running ${pkg_mgr} update"
    "${pkg_mgr}" update -y
  fi
  "${pkg_mgr}" install -y ${pkgs}
}

activate_venv() {
  if [[ -z $VIRTUAL_ENV ]]; then
    source "${ACD_VENV_DIR}/bin/activate"
  fi
}

create_venv() {
  log.info "Creating python virtualenv in ${ACD_VENV_DIR}"
  mkdir -p "${ACD_VENV_DIR}"
  python3 -m venv --copies --upgrade "${ACD_VENV_DIR}"
  activate_venv
  log.info "Upgrading pip"
  pip install --upgrade --no-input pip -qqq pip
  deactivate
}

install_ansible() {
  log.info "Installing Ansible"
  activate_venv
  pip install ansible
  echo "export ANSIBLE_DEPRECATION_WARNINGS=True" >> "${ACD_VENV_DIR}/bin/activate"
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
