#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p docs/verification
flutter pub get
dart format --output=none --set-exit-if-changed lib test
flutter analyze --no-pub --fatal-infos 2>&1 | tee docs/verification/analyze.txt
flutter test --no-pub --reporter expanded 2>&1 | tee docs/verification/tests.txt
flutter test --no-pub test/rebuild_test.dart --dart-define=MEASURE=true --dart-define=MEASUREMENT_LABEL=after --reporter expanded 2>&1 | tee docs/verification/rebuild-after.txt
flutter test --no-pub test/evidence_test.dart --dart-define=CAPTURE_EVIDENCE=true --reporter expanded 2>&1 | tee docs/verification/evidence.txt
flutter build web --release --no-pub 2>&1 | tee docs/verification/web-build.txt
