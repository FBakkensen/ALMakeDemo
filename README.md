# ALMakeDemo: Cross-Platform AL Build System Demo

Welcome to **ALMakeDemo**! This project demonstrates a robust, cross-platform build system for Microsoft Dynamics 365 Business Central AL extensions, using a unified `Makefile` and platform-specific scripts. The goal is to educate developers on best practices for automating AL builds, cleaning, and diagnostics—making it ideal for blog posts, workshops, and onboarding.

## 🚀 Key Features
- **Unified Makefile**: One entry point for all developer workflows—build, clean, show config, and analyzers.
- **Platform-Specific Scripts**: Seamless support for both Windows (PowerShell) and Linux (Bash) environments.
- **Modular Libraries**: Shared logic and helpers for JSON parsing, validation, and output formatting.
- **Strict Build Quality**: The build must run _without any warnings or errors_.

---

## 🗂️ Project Structure
```
ALMakeDemo/
├── app/                    # Main AL app (app.json + .al sources)
├── test/                   # Test app (depends on app + Library Assert)
├── Makefile                # Unified build entry point
├── scripts/
│   ├── cloud/              # Headless Linux toolchain: al CLI, ALCops, al-runner
│   └── make/
│       ├── windows/        # Windows PowerShell scripts
│       │   ├── build.ps1
│       │   ├── clean.ps1
│       │   ├── show-config.ps1
│       │   ├── show-analyzers.ps1
│       │   └── lib/
│       │       ├── common.ps1
│       │       └── json-parser.ps1
│       └── linux/          # Linux Bash scripts
│           ├── build.sh
│           ├── clean.sh
│           ├── show-config.sh
│           ├── show-analyzers.sh
│           └── lib/
│               ├── common.sh
│               └── json-parser.sh
└── ...
```

---

## 🛠️ How the Build System Works
### 1. **Makefile**
- Detects your platform (Windows or Linux).
- Delegates commands to the correct script in `scripts/make/{windows,linux}`.
- Example targets:
  - `make build` — Compile the AL project
  - `make clean` — Remove build artifacts
  - `make show-config` — Display app and analyzer config
  - `make show-analyzers` — List enabled analyzers and DLL paths

### 2. **Platform-Specific Scripts**
- **Windows**: PowerShell scripts import shared modules for common logic, JSON parsing, and error handling.
- **Linux**: Bash scripts source shared libraries for functions, validation, and output formatting.
- Both platforms:
  - Parse `app.json` and `.vscode/settings.json` for configuration.
  - Discover AL compiler and analyzers automatically.
  - Clean up conflicting files/directories before building.

### 3. **Shared Libraries**
- **Common Functions**: Path resolution, error handling, and output formatting.
- **JSON Parsers**: Robust helpers for reading and validating config files.
- **Analyzer Discovery**: Automatically finds enabled analyzers and their DLLs.

### 4. **Ruleset (Optional)**
- Provide a ruleset file to adjust analyzer severities (e.g., promote Info to Warning).
- Configure the path via `RULESET_PATH` in the `Makefile`. If the file is missing or empty, the build skips `/ruleset` automatically.
- Example default file included: `ruleset.json` with an empty rules list you can extend.

---

## 📚 Educational Highlights
- **Cross-Platform Automation**: Learn how to write scripts that work seamlessly on both Windows and Linux.
- **Modular Design**: See how shared logic is split into reusable libraries for maintainability.
- **Strict Build Quality**: Understand the importance of zero warnings/errors in professional AL development.
- **Extensible Workflows**: Easily add new targets (e.g., test, package, deploy) by following the existing structure.

---

## 🏁 Quick Start
1. **Clone the repo**
   ```poweshell
   git clone https://github.com/FBakkensen/ALMakeDemo.git
   cd ALMakeDemo
   ```
2. **Build the project**
   - On Windows:
     ```powershell
     make build
     ```
   - On Linux:
     ```sh
     make build
     ```
3. **Clean artifacts**
   ```powershell
   make clean
   ```
4. **Show configuration**
   ```powershell
   make show-config
   ```
5. **List analyzers**
   ```powershell
   make show-analyzers
   ```

6. **Build with a ruleset (optional)**
   ```sh
   RULESET_PATH=ruleset.json make build
   ```

---

## ☁️ Headless Linux / Cloud Sessions (al CLI + ALCops + al-runner)
No VS Code needed. `scripts/cloud/` uses the `al` dotnet tool to compile, the
Microsoft cops plus [ALCops](https://www.nuget.org/packages/ALCops.Analyzers) to analyze,
and [al-runner](https://github.com/StefanMaron/BusinessCentral.AL.Runner) to run tests in-process.

```sh
bash scripts/cloud/setup.sh      # once per machine (use it as the cloud environment setup script)
scripts/cloud/build.sh app       # restore symbols + compile app with analyzers
scripts/cloud/test.sh            # compile app + test app, run tests with al-runner
```

Notes:
- `setup.sh` installs the .NET 10 runtime + ASP.NET Core 10 runtime and patches
  al-runner's runtimeconfig to use them: the BC 27/28 engine DLLs it loads need
  .NET 10 (`System.Diagnostics.EventLog 10.0`), and fail on .NET 8 alone.
- The AL tool package is `Microsoft.Dynamics.BusinessCentral.Development.Tools`;
  the `.Linux` package is only a library dependency and can't be installed as a tool.
- Symbols come straight from the public MSSymbols NuGet feed (`restore-symbols.py`), no mono/nuget.exe.
- al-runner only ships BC 27.x/28.x engines, so tests run on BC 28.5 (`BC_VERSION`) while
  the app still compiles against its declared `application` version (26.x).

---

## 📝 For Blog Posts & Demos
This repo is designed for educational use—feel free to reference, fork, or adapt it for:
- Blog tutorials on AL build automation
- Workshops and training sessions
- Onboarding new AL developers
- Comparing Windows vs Linux scripting approaches

---

## 📖 Further Reading
- [Microsoft Docs: AL Language](https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-extensions)
- [Makefile Tutorial](https://www.gnu.org/software/make/manual/make.html)
- [PowerShell Scripting](https://learn.microsoft.com/en-us/powershell/scripting/overview)
- [Bash Scripting Guide](https://www.gnu.org/software/bash/manual/bash.html)

---

## 💡 Feedback & Contributions
If you spot any issues or have suggestions for improving the educational value of this demo, please open an issue or pull request!

---

**Happy building!**
