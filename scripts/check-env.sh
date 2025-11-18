#!/usr/bin/env bash
set -euo pipefail

missing=()

check_cmd(){
  if ! command -v "$1" >/dev/null 2>&1; then
    missing+=("$1")
  else
    echo "OK: $1 -> $($1 --version 2>&1 | head -n1)"
  fi
}

echo "Running quick environment checks..."
check_cmd java || true
check_cmd mvn || true
check_cmd docker || true

if [ ${#missing[@]} -ne 0 ]; then
  echo
  echo "Missing required commands: ${missing[*]}"
  echo "Please install them before running the full pipeline. Quick hints:"
  echo "  - Java 17: https://adoptium.net/ or your distro packages"
  echo "  - Maven: https://maven.apache.org/install.html  (or add Maven Wrapper to the repo)"
  echo "  - Docker: https://docs.docker.com/engine/install/"
  exit 1
fi

echo "All required commands are present." 
