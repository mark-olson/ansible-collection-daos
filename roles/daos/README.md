# mark-olson.daos.daos

This Ansible role will install and configure DAOS.

> In Ansible terminology a *compute instance* is referred to as a *host*. A host can be a bare metal machine, VM, or container. The term *host* will be used in the documentation below to refer to any target where the `daos-stack.daos` *Ansible role* will run.

In this documentation the term "role" is used to refer to the `daos-stack.daos` *Ansible role* as well as the role that a host is assigned within a [DAOS system](https://docs.daos.io/latest/overview/architecture/#daos-system).

In a [DAOS system](https://docs.daos.io/latest/overview/architecture/#daos-system) hosts can be assigned one or more of the following roles:

- **DAOS Server**
  Runs the DAOS Server multi-tenant daemon. Its Engine sub-processes export the locally-attached SCM and NVM storage through the network.
- **DAOS Client**
  Runs the DAOS agent daemon that interacts with the DAOS library to authenticate application processes. The agent daemon can support different authentication frameworks, and uses a Unix Domain Socket to communicate with the DAOS library.
- **DAOS Admin**
  Has the DAOS admin utilities installed. Typically used by administrators to manage the DAOS system.

When using the `daos-stack.daos` Ansible role to install a DAOS on a target host, you must determine the *role* that host will be assigned within the DAOS system. For more information see the documentation for the `daos_role` variable below.

## Requirements

Any pre-requisites that may not be covered by Ansible itself or the role should be mentioned here. For instance, if the role uses the EC2 module, it may be a good idea to mention in this section that the boto package is required.

## Role Variables

A description of the settable variables for this role should go here, including any variables that are in defaults/main.yml, vars/main.yml, and any variables that can/should be set via parameters to the role. Any variables that are read from other roles and/or the global scope (ie. hostvars, group vars, etc.) should be mentioned here as well.

## Dependencies

A list of other roles hosted on Galaxy should go here, plus any details in regards to parameters that may need to be set for other roles, or variables that are used from other roles.

## Example Playbook

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: daos_servers
      roles:
         - { role: daos-stack.daos.daos, daos_roles: [server] }


## Installation Scenarios

### Local Connections

1. Packer provisioner to install DAOS for image builds
2. Configure systems in a startup script
   1. Config files
   2. Certificates
3. Configure a single server
4. Configure a developer workstation
5. Install DAOS by compiling daos-dev

### Remote Connections

1. Configure a single server
2. Install a cluster on a set of nodes
3. Perform configuration only
4. Configure a developer workstation
