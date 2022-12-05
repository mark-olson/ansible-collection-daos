# reboot

Reboots the host if a reboot is needed.

Other roles can simply run

```
touch /etc/ansible/reboot
```

If they want a reboot to occur when the do.reboot role runs which is typically
the last role that appears in a playbook.

If the /etc/ansible/reboot file exists then this role will not check the state
of the host to determine if it needs a reboot or not.  It will simply reboot
the node.

If the /etc/ansible/reboot file does not exist then the role will check to
see if the host needs a reboot.  The method for determining if a reboot is
needed is different depending on the OS.

If you want to prevent this role from rebooting the host regardless of the
existence of a /etc/ansible/reboot file or if the host needs a reboot, you can
set

```
reboot_disable=yes
```

## Requirements

Ansible 2.11 or greater

## Role Variables

See [defaults/main.yml](defaults/main.yml)

## Dependencies

None

## Example Playbook

```yaml
---
- name: Install and configure reboot
  hosts: all

  roles:
    - reboot
```

## License

Apache-2.0
