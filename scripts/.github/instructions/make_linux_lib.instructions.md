---
applyTo: '**/scripts/make/linux/lib/**/*'
---
# Linux Build System Libraries

This folder contains reusable shell functions and utilities for the Linux build system.

## Library Components

- **Common Functions**: Shared utilities across scripts
- **Color Output**: Terminal formatting functions
- **Logging**: Structured logging utilities
- **Validation**: Input and environment checks
- **Docker Helpers**: Container management functions

## Function Categories

### Output Functions
```bash
info() { echo -e "\033[0;32m[INFO]\033[0m $1"; }
warn() { echo -e "\033[0;33m[WARN]\033[0m $1"; }
error() { echo -e "\033[0;31m[ERROR]\033[0m $1"; }
```

### Validation Functions
- `check_command()`: Verify command availability
- `check_file()`: Validate file existence
- `check_env()`: Ensure environment variables
- `validate_version()`: Check version formats

### Docker Functions
- `container_exists()`: Check container presence
- `container_running()`: Verify container state
- `exec_in_container()`: Run commands in container
- `copy_to_container()`: Transfer files

## Best Practices

- Source libraries consistently
- Document function parameters
- Return meaningful exit codes
- Handle edge cases
- Keep functions focused

## Usage Pattern

```bash
#!/bin/bash
source "$(dirname "$0")/lib/common.sh"
source "$(dirname "$0")/lib/docker.sh"

info "Starting build process..."
check_command "docker" || exit 1
```

## Error Handling

- Use return codes consistently
- Provide helpful error messages
- Clean up resources on failure
- Log errors for debugging

## Performance

- Minimize external command calls
- Cache repeated operations
- Use built-in bash features
- Avoid unnecessary loops