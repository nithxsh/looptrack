#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUTPUT_DIR="${ROOT_DIR}/apk"

if ! command -v flutter >/dev/null 2>&1; then
  echo "Error: Flutter is not installed or not in PATH." >&2
  echo "Install Flutter: https://docs.flutter.dev/get-started/install" >&2
  exit 1
fi

cd "$ROOT_DIR"
flutter pub get
flutter build apk --release

mkdir -p "$OUTPUT_DIR"
cp build/app/outputs/flutter-apk/app-release.apk "$OUTPUT_DIR/looptrack-release.apk"

echo "APK generated at: $OUTPUT_DIR/looptrack-release.apk"
