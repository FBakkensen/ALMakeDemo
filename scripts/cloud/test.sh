#!/bin/bash
# Build the app and its test app, then run the tests in-process with al-runner.
# Usage: test.sh [extra al-runner args...]   e.g. test.sh --test FactBox
set -euo pipefail
export PATH="$HOME/.dotnet/tools:$PATH"

REPO_ROOT="$(readlink -f "$(dirname "$0")/../..")"
BC_VERSION="${BC_VERSION:-28.5}"   # al-runner ships engines for BC 27.x / 28.x only

"$REPO_ROOT/scripts/cloud/build.sh" "$REPO_ROOT/app"
"$REPO_ROOT/scripts/cloud/build.sh" "$REPO_ROOT/test" "$REPO_ROOT/app/out"

al-runner --bc-version "$BC_VERSION" "$@" "$REPO_ROOT/app" "$REPO_ROOT/test"
