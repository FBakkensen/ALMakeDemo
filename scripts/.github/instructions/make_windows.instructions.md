---
applyTo: '**/scripts/make/windows/**/*'
---
# Windows Build Scripts

This folder contains Windows-specific build scripts and utilities for the make system.

## Script Types

- **PowerShell Scripts**: Modern Windows scripting
- **Batch Files**: Legacy compatibility scripts
- **Helper Modules**: Reusable PowerShell modules
- **Environment Scripts**: Windows-specific setup

## Windows Specifics

- Handle backslashes in paths
- Manage case-insensitive filesystems
- Work with Windows permissions
- Support long path names
- Handle drive letters

## Common Scripts

- `build.ps1`: Main build script
- `test.ps1`: Test execution
- `setup-env.ps1`: Environment preparation
- `check-deps.ps1`: Dependency verification

## PowerShell Best Practices

```powershell
#Requires -Version 5.1
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
```

## Path Handling

```powershell
# Convert paths for cross-platform compatibility
$path = $path.Replace('\', '/')
# Handle UNC paths
$uncPath = "\\server\share\folder"
```

## Docker Desktop Integration

- Check Docker Desktop running
- Handle Windows containers
- Manage Linux containers on Windows
- Support WSL2 backend
- Configure volume mounts

## Error Handling

```powershell
try {
    # Command
} catch {
    Write-Error "Failed: $_"
    exit 1
}
```

## Environment Variables

```powershell
# Set for session
$env:VARIABLE = "value"
# Set permanently
[Environment]::SetEnvironmentVariable("VARIABLE", "value", "User")
```

## Execution Policy

Consider execution policy:
- Check current policy
- Handle restricted environments
- Document policy requirements
- Provide bypass instructions