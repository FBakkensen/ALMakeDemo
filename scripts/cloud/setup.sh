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
#   - al-runner's BC engine + platform/test apps (PREPROVISION_BC, so the first test run is fast)
# Fails loudly: any failed step, or a tool missing at the end, exits non-zero.
#
# Env (all optional):
#   AL_TOOL_VERSION / AL_RUNNER_VERSION  pin a tool version (default: latest stable)
#   ALCOPS_VERSION                       default 1.3.1
#   PREPROVISION_BC                      BC version for al-runner artifacts (default 28.5, empty = skip)
set -euo pipefail

ALCOPS_VERSION="${ALCOPS_VERSION:-1.3.1}"
PREPROVISION_BC="${PREPROVISION_BC-28.5}"
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
dotnet tool update -g Microsoft.Dynamics.BusinessCentral.Development.Tools ${AL_TOOL_VERSION:+--version "$AL_TOOL_VERSION"}
dotnet tool update -g MSDyn365BC.AL.Runner ${AL_RUNNER_VERSION:+--version "$AL_RUNNER_VERSION"}

# ~/.dotnet/tools is not on PATH for non-interactive shells (where agents run commands),
# so link the tools into /usr/local/bin as well.
for tool in al al-runner; do
    ln -sf "$HOME/.dotnet/tools/$tool" "/usr/local/bin/$tool"
done

# WORKAROUND for an al-runner bug in releases up to 2.12.0 (fixed on main): it ships
# net8 runtimeconfigs but loads BC service-tier DLLs built for .NET 10, and crashes on
# System.Diagnostics.EventLog 10.0. Run it on .NET 10 with the ASP.NET Core framework
# referenced so the framework's EventLog 10.0 wins over the bundled 8.0 copy.
# Skipped automatically for newer releases; delete this block once they ship.
INSTALLED_AL_RUNNER="$(al-runner --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1)"
if [[ "$(printf '%s\n' "$INSTALLED_AL_RUNNER" 2.12.0 | sort -V | head -1)" == "$INSTALLED_AL_RUNNER" ]]; then
    echo "Patching al-runner $INSTALLED_AL_RUNNER to run on .NET 10 (EventLog workaround)"
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

# --- Pre-provision al-runner artifacts (~140 MB engine + apps; otherwise the first test run downloads them) ---
if [[ -n "$PREPROVISION_BC" ]]; then
    for set in --service-tier --platform-apps --test-apps; do
        al-runner provision "$set" --bc-version "$PREPROVISION_BC"
    done
fi

# --- Verify (from a clean PATH, the way agents will call the tools) ---
env PATH=/usr/local/bin:/usr/bin:/bin al --version | head -1
env PATH=/usr/local/bin:/usr/bin:/bin al-runner --version | head -1
ls "$ALCOPS_DIR"/ALCops.Common.dll >/dev/null
echo "ALCops:    $ALCOPS_DIR"
echo "AL toolchain ready."
