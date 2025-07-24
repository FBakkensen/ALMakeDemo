# Copilot Instructions for ALMakeDemo

## Project Overview
This is a cross-platform AL (Business Central) extension project. The codebase is structured to support both Windows and Linux builds using platform-specific scripts, with a unified Makefile as the entry point for developer workflows.

## Key Components
- `app.json`: Main AL app manifest. Defines app metadata, publisher, version, and features.
- `Makefile`: Orchestrates builds, cleans, and diagnostics. Detects platform and delegates to scripts in `scripts/make/{windows,linux}`.
- `scripts/make/windows/` and `scripts/make/linux/`: Contains PowerShell and Bash scripts for build, clean, config, and analyzer operations. Each script imports shared logic from their respective `lib/` directories.

## Build & Clean Workflow

- **Build:** Run `make build` (or just `make`). This calls the platform-specific build script:
  - Windows: `scripts/make/windows/build.ps1`
  - Linux: `scripts/make/linux/build.sh`
  - The build output is piped to both the terminal and `build.log` using `tee`. Always read `build.log` for the complete build output and diagnostics.
- **Clean:** Run `make clean` to remove build artifacts.
- **Show Config/Analyzers:** Use `make show-config` and `make show-analyzers` for diagnostics.

## AL Compiler & Analyzers
- The build scripts auto-discover the AL compiler (`alc.exe`) from the highest version of the VS Code AL extension installed.
- Analyzer DLLs (e.g., CodeCop, UICop) are enabled via `.vscode/settings.json` or defaulted if not specified. The scripts resolve their paths automatically.
- Output `.app` files are named using the pattern `{Publisher}_{AppName}_{Version}.app` and placed in the app directory.

## Project-Specific Patterns
- All shared logic for script operations is in `lib/common.ps1` (Windows) and `lib/common.sh` (Linux).
- JSON parsing helpers are in `lib/json-parser.ps1` and `lib/json-parser.sh`.
- AL objects should use unique IDs and names, as shown in `HelloWorld.al`.
- The build scripts remove both files and directories that conflict with the output artifact name before building.

## External Dependencies
- Relies on the VS Code AL extension for compilation and analyzers.
- No other external services or APIs are integrated.

## Quick Reference
- **Build:** `make build` or `make`
- **Clean:** `make clean`
- **Show Config:** `make show-config`
- **Show Analyzers:** `make show-analyzers`
- **Main build script:** `scripts/make/windows/build.ps1` (Windows), `scripts/make/linux/build.sh` (Linux)
- **App manifest:** `app.json`
- **Sample AL object:** `HelloWorld.al`

---
If any section is unclear or missing important details, please provide feedback so this guide can be improved for future AI agents.
