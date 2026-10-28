#!/usr/bin/env bash
set -euo pipefail

if ! command -v gradle >/dev/null 2>&1; then
  echo "Gradle is not installed or not available on PATH."
  echo "This repo is missing the generated Gradle wrapper files, so this shim uses the installed Gradle binary instead."
  exit 1
fi

exec gradle "$@"
