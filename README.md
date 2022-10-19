# Ansible Collection for DAOS

Ansible Collection for DAOS

**Warning**

This repo is experimental and should not be used for production.

## Patch podman.py

Roles in this ansible collection are tested with podman.

Unfortunately, there is a bug which needs a patch.

To apply the patch, run:

```bash
podman_path=$(find $VIRTUAL_ENV -type f -name podman.py)
patch $podman_path podman.py.patch
```

## Testing roles with molecule

```bash
cd roles/<role_name>
molecule test
```
