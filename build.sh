#!/usr/bin/env bash
set -euo pipefail

# Install Flutter stable in Vercel's build environment.
FLUTTER_DIR="/tmp/flutter"
if [ ! -x "$FLUTTER_DIR/bin/flutter" ]; then
  git clone --depth 1 --branch stable https://github.com/flutter/flutter.git "$FLUTTER_DIR"
fi
export PATH="$FLUTTER_DIR/bin:$PATH"

flutter --version
flutter config --enable-web
# Generate the web platform folder if it is not already present.
if [ ! -d web ]; then
  flutter create . --platforms web
fi
flutter pub get
flutter build web --release
