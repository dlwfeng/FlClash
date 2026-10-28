#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."
bash tool/flutter_locked.sh build web --release --target lib/remote/main.dart --output build/remote-web --no-web-resources-cdn

if [[ $# -gt 0 ]]; then
  if [[ ! -d "$1/Contents/Resources" ]]; then
    echo 'Expected a macOS .app bundle as the first argument' >&2
    exit 1
  fi
  mkdir -p "$1/Contents/Resources/remote-web"
  rsync -a --delete build/remote-web/ "$1/Contents/Resources/remote-web/"
fi
