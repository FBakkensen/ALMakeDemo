---
applyTo: '**/scripts/make/linux/**/*'
---
# Linux Build Scripts

This folder contains Linux-specific build scripts and utilities for the make system.

## Script Types

- **Shell Scripts**: Bash/sh scripts for Linux
- **Helper Functions**: Common Linux utilities
- **Environment Setup**: Linux-specific configuration
- **Tool Wrappers**: Linux command adaptations

## Linux Specifics

- Use forward slashes for paths
- Handle case-sensitive filesystems
- Manage permissions correctly
- Support different shell types
- Handle package managers

## Common Scripts

- `build.sh`: Main build script
- `test.sh`: Test execution
- `setup-env.sh`: Environment preparation
- `check-deps.sh`: Dependency verification

## Best Practices

- Use `#!/bin/bash` shebang
- Check for bash version
- Handle spaces in paths
- Use proper quoting
- Set -e for error handling

## Docker Integration

- Mount volumes correctly
- Handle container networking
- Manage permissions in containers
- Support rootless Docker
- Handle SELinux contexts

## Error Handling

```bash
set -euo pipefail
trap 'echo "Error on line $LINENO"' ERR
```

## Platform Detection

```bash
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux specific code
fi
```