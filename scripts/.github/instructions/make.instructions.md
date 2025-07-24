---
applyTo: '**/scripts/make/**/*'
---
# Make Build System

This folder contains the make-based build system for consistent builds across different platforms and environments.

## Make Structure

- **Makefile**: Main build configuration
- **Platform-specific**: Linux and Windows implementations
- **Targets**: Build, test, deploy commands
- **Variables**: Configuration settings
- **Dependencies**: Build prerequisites

## Common Make Targets

Standard targets include:
- `make build`: Build the extension
- `make test`: Run test suite
- `make clean`: Clean build artifacts
- `make deploy`: Deploy to environment
- `make package`: Create deployment package
- `make all`: Complete build pipeline

## Platform Handling

The make system handles:
- Windows vs Linux path differences
- Shell command variations
- Tool availability checks
- Environment setup
- Container orchestration

## Build Configuration

Key configuration options:
```makefile
VERSION := 1.0.0
BC_VERSION := 21.0
ENVIRONMENT := development
DEBUG := false
```

## Dependency Management

- Check for required tools
- Verify BC artifacts
- Ensure container availability
- Validate credentials
- Download dependencies

## Best Practices

- Keep Makefile readable
- Use meaningful target names
- Document all targets
- Implement .PHONY correctly
- Support parallel execution

## Error Handling

- Check command success
- Provide informative errors
- Clean up on failure
- Support verbose output
- Enable debug mode

## Variable Usage

Common variables:
- `$(APP_NAME)`: Extension name
- `$(BUILD_DIR)`: Output directory
- `$(SOURCE_DIR)`: Source location
- `$(TEST_RESULTS)`: Test output
- `$(ARTIFACTS)`: Build artifacts

## Integration

Make integrates with:
- Docker for BC containers
- AL compiler
- Test runners
- Package managers
- CI/CD systems