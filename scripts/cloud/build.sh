#!/bin/bash
# Compile an AL project with the `al` CLI, Microsoft cops and ALCops.
# Usage: build.sh <project-dir> [extra package cache dir]
# Env:   WARN_AS_ERROR=1 (default) adds /warnaserror+; RULESET_PATH (default: ruleset.json in repo root)
set -euo pipefail
export PATH="$HOME/.dotnet/tools:$PATH"

PROJECT="$(readlink -f "${1:?usage: build.sh <project-dir> [extra-package-cache]}")"
EXTRA_CACHE="${2:-}"
REPO_ROOT="$(readlink -f "$(dirname "$0")/../..")"
RULESET_PATH="${RULESET_PATH:-$REPO_ROOT/ruleset.json}"
ALCOPS_DIR="$(ls -d "$HOME"/.alcops/*/ 2>/dev/null | sort -V | tail -1)"
MS_COPS_DIR="$(dirname "$(find "$HOME/.dotnet/tools/.store/microsoft.dynamics.businesscentral.development.tools" \
    -path '*/net8.0/*' -name Microsoft.Dynamics.Nav.CodeCop.dll | sort -V | tail -1)")"

[[ -d "$PROJECT/.alpackages" ]] || python3 -I "$REPO_ROOT/scripts/cloud/restore-symbols.py" "$PROJECT"

name="$(jq -r '"\(.publisher)_\(.name)_\(.version)"' "$PROJECT/app.json")"
out_dir="$PROJECT/out"
mkdir -p "$out_dir"

cache="$PROJECT/.alpackages"
[[ -n "$EXTRA_CACHE" ]] && cache="$cache;$EXTRA_CACHE"

args=("/project:$PROJECT" "/packagecachepath:$cache" "/out:$out_dir/$name.app")
[[ -s "$RULESET_PATH" ]] && args+=("/ruleset:$RULESET_PATH")
for cop in CodeCop UICop PerTenantExtensionCop; do
    args+=("/analyzer:$MS_COPS_DIR/Microsoft.Dynamics.Nav.$cop.dll")
done
if [[ -n "$ALCOPS_DIR" ]]; then
    # ALCops.Common must be passed too, otherwise the cops cannot resolve it at runtime
    for dll in "$ALCOPS_DIR"ALCops.*.dll; do
        args+=("/analyzer:$dll")
    done
else
    echo "warning: ALCops not found in ~/.alcops (run scripts/cloud/setup.sh)" >&2
fi
[[ "${WARN_AS_ERROR:-1}" == "1" ]] && args+=("/warnaserror+")

al compile "${args[@]}"
