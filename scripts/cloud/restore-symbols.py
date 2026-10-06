#!/usr/bin/env python3
"""Restore Business Central symbol packages for an AL project without mono/nuget.exe.

Reads <project>/app.json and downloads into <project>/.alpackages:
  - Microsoft.Application.symbols (and its dependencies: System, System Application,
    Base Application, Business Foundation) for the major version in "application"
  - every Microsoft dependency listed in "dependencies" (e.g. Library Assert)

Packages come straight from the public MSSymbols NuGet feed (flat container API).
Non-Microsoft dependencies are skipped; compile those first and point
/packagecachepath at their output.

Usage: restore-symbols.py <project-dir>
"""
import io
import json
import os
import re
import sys
import urllib.request
import zipfile

FEED = ("https://dynamicssmb2.pkgs.visualstudio.com/571e802d-b44b-45fc-bd41-4cfddec73b44"
        "/_packaging/b656b10c-3de0-440c-900c-bc2e4e86d84c/nuget/v3/flat2")


def version_key(v):
    return [int(x) for x in re.findall(r"\d+", v)]


def fetch(url):
    with urllib.request.urlopen(url) as r:
        return r.read()


def latest_in_major(package, major):
    try:
        versions = json.loads(fetch(f"{FEED}/{package}/index.json"))["versions"]
    except urllib.error.HTTPError:
        return None
    versions = [v for v in versions if "-" not in v and v.split(".")[0] == major]
    return max(versions, key=version_key) if versions else None


def main():
    if len(sys.argv) != 2:
        sys.exit(__doc__)
    project = sys.argv[1]
    with open(os.path.join(project, "app.json"), encoding="utf-8-sig") as f:
        app = json.load(f)
    major = app["application"].split(".")[0]
    out = os.path.join(project, ".alpackages")
    os.makedirs(out, exist_ok=True)

    todo = ["microsoft.application.symbols"]
    for dep in app.get("dependencies", []):
        if dep["publisher"] == "Microsoft":
            todo.append(f"microsoft.{dep['name'].replace(' ', '')}.symbols.{dep['id']}")
        else:
            print(f"skip non-Microsoft dependency: {dep['publisher']} {dep['name']}")

    seen = set()
    while todo:
        package = todo.pop().lower()
        if package in seen:
            continue
        seen.add(package)
        version = latest_in_major(package, major)
        if not version:
            sys.exit(f"error: no {major}.x version of {package} in MSSymbols feed")
        nupkg = zipfile.ZipFile(io.BytesIO(fetch(f"{FEED}/{package}/{version}/{package}.{version}.nupkg")))
        for name in nupkg.namelist():
            if name.endswith(".app"):
                target = os.path.join(out, os.path.basename(name))
                with open(target, "wb") as f:
                    f.write(nupkg.read(name))
                print(f"{package} {version} -> {target}")
            elif name.endswith(".nuspec"):
                todo += re.findall(r'<dependency id="([^"]+)"', nupkg.read(name).decode("utf-8", "ignore"))


if __name__ == "__main__":
    main()
