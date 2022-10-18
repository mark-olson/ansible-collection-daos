# Ansible Collection for DAOS

Ansible Collection for DAOS

**Warning**

This repo is experimental and should not be used for production.

## Patch podman.py

```bash
podman_path=$(find $VIRTUAL_ENV -type f -name podman.py)
patch $podman_path podman.py.patch
```

## Test with molecule

```bash
pushd roles/daos
molecule test
```
