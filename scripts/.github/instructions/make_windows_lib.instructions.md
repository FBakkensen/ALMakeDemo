---
applyTo: '**/scripts/make/windows/lib/**/*'
---
# Windows Build System Libraries

This folder contains reusable PowerShell modules and functions for the Windows build system.

## Library Components

- **Common Module**: Shared utilities across scripts
- **Logging Module**: Structured logging functions
- **Docker Module**: Container management utilities
- **Validation Module**: Input and environment checks
- **Build Helpers**: Build-specific functions

## Module Structure

### Common Functions
```powershell
function Write-Info($message) {
    Write-Host "[INFO] $message" -ForegroundColor Green
}

function Write-Warning($message) {
    Write-Host "[WARN] $message" -ForegroundColor Yellow
}

function Write-Error($message) {
    Write-Host "[ERROR] $message" -ForegroundColor Red
}
```

### Validation Functions
- `Test-Command`: Check if command exists
- `Test-Environment`: Validate env variables
- `Test-Prerequisites`: Check all requirements
- `Test-DockerRunning`: Verify Docker state

### Docker Functions
- `Get-Container`: Retrieve container info
- `Invoke-ContainerCommand`: Execute in container
- `Copy-ToContainer`: Transfer files
- `New-BCContainer`: Create BC container

## Best Practices

- Use approved verbs for functions
- Include comment-based help
- Implement parameter validation
- Support pipeline input
- Return objects when appropriate

## Usage Pattern

```powershell
# Import modules
Import-Module "$PSScriptRoot\lib\Common.psm1"
Import-Module "$PSScriptRoot\lib\Docker.psm1"

Write-Info "Starting build process..."
if (-not (Test-Command "docker")) {
    throw "Docker not found"
}
```

## Error Handling

- Use try/catch blocks
- Throw meaningful exceptions
- Support -ErrorAction parameter
- Log errors appropriately

## Performance Optimization

- Minimize module load time
- Cache expensive operations
- Use .NET methods when faster
- Avoid unnecessary type conversions

## Module Best Practices

- Export only public functions
- Use module manifests (.psd1)
- Version modules appropriately
- Document all exported functions
- Include Pester tests