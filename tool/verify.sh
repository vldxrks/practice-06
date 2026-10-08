#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p docs/verification
flutter --version | tee docs/verification/flutter-version.txt
flutter pub get
flutter analyze --fatal-infos | tee docs/verification/analyze.txt
flutter test --reporter expanded | tee docs/verification/tests.txt
flutter test test/evidence_test.dart --dart-define=CAPTURE_EVIDENCE=true --reporter expanded | tee docs/verification/evidence.txt
flutter build web --release | tee docs/verification/web-build.txt
python3 tool/finalize_evidence.py
