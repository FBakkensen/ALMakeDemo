#!/bin/bash
# One-time toolchain setup for Linux / Claude Code cloud environments.
# Idempotent: safe to re-run. Suitable as the cloud environment "setup script".
#
# Installs:
#   - .NET 10 runtime + ASP.NET Core 10 runtime (al-runner prerequisite; BC 27/28
#     service-tier DLLs reference .NET 10 assemblies such as System.Diagnostics.EventLog 10.0)
#   - `al`        Microsoft.Dynamics.BusinessCentral.Development.Tools (AL compiler CLI + Microsoft cops)
#   - `al-runner` MSDyn365BC.AL.Runner (in-process AL test runner)
#   - ALCops analyzers into ~/.alcops
set -euo pipefail

ALCOPS_VERSION="${ALCOPS_VERSION:-1.3.1}"
DOTNET_DIR="$(dirname "$(readlink -f "$(command -v dotnet)")")"
export PATH="$HOME/.dotnet/tools:$PATH"

# --- .NET 10 runtimes (side by side with the existing SDK) ---
if ! dotnet --list-runtimes | grep -q "Microsoft.AspNetCore.App 10\."; then
    curl -sSL -o /tmp/dotnet-install.sh https://dot.net/v1/dotnet-install.sh
    bash /tmp/dotnet-install.sh --channel 10.0 --runtime dotnet --install-dir "$DOTNET_DIR"
    bash /tmp/dotnet-install.sh --channel 10.0 --runtime aspnetcore --install-dir "$DOTNET_DIR"
fi

# --- dotnet tools ---
# Note: the package is Microsoft.Dynamics.BusinessCentral.Development.Tools; the
# ".Linux" package is only a library dependency, not an installable tool.
dotnet tool update -g Microsoft.Dynamics.BusinessCentral.Development.Tools
dotnet tool update -g MSDyn365BC.AL.Runner

# WORKAROUND for an al-runner bug in releases up to 2.12.0 (fixed on main): it ships
# net8 runtimeconfigs but loads BC service-tier DLLs built for .NET 10, and crashes on
# System.Diagnostics.EventLog 10.0. Run it on .NET 10 with the ASP.NET Core framework
# referenced so the framework's EventLog 10.0 wins over the bundled 8.0 copy.
# Skipped automatically for newer releases; delete this block once they ship.
AL_RUNNER_VERSION="$(al-runner --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)"
if [[ "$(printf '%s\n' "$AL_RUNNER_VERSION" 2.12.0 | sort -V | head -1)" == "$AL_RUNNER_VERSION" ]]; then
    echo "Patching al-runner $AL_RUNNER_VERSION to run on .NET 10 (EventLog workaround)"
    find "$HOME/.dotnet/tools/.store/msdyn365bc.al.runner" -name al-runner.runtimeconfig.json -print0 |
        xargs -0 python3 -I -c '
import json, sys
for path in sys.argv[1:]:
    with open(path) as f:
        cfg = json.load(f)
    opts = cfg["runtimeOptions"]
    opts.pop("framework", None)
    opts["tfm"] = "net10.0"
    opts["frameworks"] = [{"name": "Microsoft.NETCore.App", "version": "10.0.0"},
                          {"name": "Microsoft.AspNetCore.App", "version": "10.0.0"}]
    with open(path, "w") as f:
        json.dump(cfg, f, indent=2)
'
    rm -rf "$HOME/.cache/al-runner/ncl-shadow"   # shadow copies carry the old runtimeconfig
fi

# --- ALCops analyzers ---
ALCOPS_DIR="$HOME/.alcops/$ALCOPS_VERSION"
if [[ ! -f "$ALCOPS_DIR/ALCops.Common.dll" ]]; then
    mkdir -p "$ALCOPS_DIR"
    curl -sSL -o /tmp/alcops.nupkg \
        "https://api.nuget.org/v3-flatcontainer/alcops.analyzers/$ALCOPS_VERSION/alcops.analyzers.$ALCOPS_VERSION.nupkg"
    unzip -oqj /tmp/alcops.nupkg 'lib/net8.0/*' -d "$ALCOPS_DIR"
fi

# Make the dotnet tools available in new shells
grep -q '.dotnet/tools' "$HOME/.bashrc" 2>/dev/null || echo 'export PATH="$HOME/.dotnet/tools:$PATH"' >> "$HOME/.bashrc"

echo "al:        $(al --version 2>/dev/null | head -1)"
echo "al-runner: $(al-runner --version 2>/dev/null | head -1)"
echo "ALCops:    $ALCOPS_DIR"
