---
applyTo: '**/scripts/**/*'
---
# Build and Deployment Scripts

This folder contains scripts for building, testing, and deploying the Project-Based Manufacturing extension across different platforms.

## Script Organization

- **make**: Cross-platform build system
- **CI/CD Scripts**: Automated deployment pipelines
- **Utility Scripts**: Development helper tools
- **Testing Scripts**: Automated test execution
- **Release Scripts**: Package and publish procedures

## Supported Platforms

Scripts support:
- Windows (PowerShell, batch)
- Linux (bash, shell)
- macOS (bash, zsh)
- Docker containers
- GitHub Actions

## Build Process

Standard build steps:
1. Clean previous builds
2. Compile AL code
3. Run tests
4. Generate packages
5. Create artifacts

## Script Standards

- Use consistent error handling
- Provide helpful output messages
- Support verbose/quiet modes
- Enable dry-run options
- Document script parameters

## Common Operations

- `build`: Compile the extension
- `test`: Run automated tests
- `package`: Create .app package
- `deploy`: Install to environment
- `clean`: Remove build artifacts

## Environment Variables

Key variables used:
- `BC_CONTAINER`: Docker container name
- `VERSION`: Extension version
- `ENVIRONMENT`: Target environment
- `BUILD_MODE`: Debug/Release
- `TEST_SUITE`: Test categories to run

## Best Practices

- Make scripts idempotent
- Check prerequisites before running
- Use exit codes appropriately
- Log operations for debugging
- Support configuration files

## Error Handling

- Validate inputs before processing
- Provide clear error messages
- Clean up on failure
- Return meaningful exit codes
- Support rollback where possible

## Cross-Platform Compatibility

- Use platform-agnostic commands
- Handle path separators correctly
- Check for required tools
- Provide platform-specific alternatives
- Test on all supported platforms

## Documentation

Each script should include:
- Purpose and description
- Required parameters
- Optional flags
- Example usage
- Dependencies