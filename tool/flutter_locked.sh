#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."
export PUB_HOSTED_URL=https://pub.dev

case "${1:-}" in
  build|run|test|analyze)
    ;;
  pub)
    if [[ "${2:-}" != get ]]; then
      echo 'Only pub get is supported; dependency upgrades require an explicit lockfile update.' >&2
      exit 2
    fi
    ;;
  *)
    echo 'Usage: tool/flutter_locked.sh {build|run|test|analyze|pub get} [arguments...]' >&2
    exit 2
    ;;
esac

lock_snapshot=$(mktemp)
trap 'rm -f "$lock_snapshot"' EXIT
cp pubspec.lock "$lock_snapshot"
if [[ "$1" == pub ]]; then
  flutter pub get --enforce-lockfile "${@:3}"
else
  flutter pub get --enforce-lockfile
fi
if ! cmp -s pubspec.lock "$lock_snapshot"; then
  echo 'Dependency resolution changed pubspec.lock; refusing to continue.' >&2
  exit 1
fi
if [[ "$1" != pub ]]; then
  flutter "$@" --no-pub
fi
