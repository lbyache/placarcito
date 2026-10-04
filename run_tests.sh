#!/usr/bin/env bash
set -e

echo "Compilando suite de pruebas de placarcito..."

DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcrun -sdk iphonesimulator swiftc \
  -target arm64-apple-ios26.5-simulator \
  -F /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Library/Frameworks \
  placarcito/Models/*.swift placarcito/Services/*.swift placarcitoTests/*.swift \
  -o /tmp/placarcitoTestRunner

# Ensure iOS Simulator is booted
DEVICE_ID="7C5BB601-FE22-44B2-AD7A-13426200BAFE"
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcrun simctl boot "$DEVICE_ID" 2>/dev/null || true

echo "Ejecutando pruebas en el simulador..."

DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcrun simctl spawn "$DEVICE_ID" /tmp/placarcitoTestRunner
