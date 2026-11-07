#!/usr/bin/env bash
set -euo pipefail

# Re-sign + export a signed IPA from the .xcarchive produced by
# `flutter build ipa --no-codesign`.
#
# Why this exists:
#   The Runner Xcode project uses Automatic code signing, which requires an
#   Apple account logged into Xcode at archive time. CI runners have no such
#   account, so a codesigning archive fails with:
#     "No Accounts: Add a new account in Accounts settings."
#     "No profiles for '<bundle id>' were found ..."
#   The build is therefore archived with --no-codesign, and this script
#   performs the manual re-sign + export using the distribution provisioning
#   profile + certificate declared in ios/ExportOptions.plist.

ARCHIVE_PATH="build/ios/archive/Runner.xcarchive"
if [ ! -d "$ARCHIVE_PATH" ]; then
  ARCHIVE_PATH=$(find build/ios -maxdepth 4 -type d -name "*.xcarchive" | head -1 || true)
fi
if [ -z "${ARCHIVE_PATH:-}" ] || [ ! -d "$ARCHIVE_PATH" ]; then
  echo "[ERROR] No .xcarchive found. Did the build run with --no-codesign?"
  find build/ios -maxdepth 4 -type d 2>/dev/null || true
  exit 1
fi
echo "[export_signed_ipa] Archive: $ARCHIVE_PATH"

# Flutter's App.framework/Info.plist ships MinimumOSVersion as an empty string
# on some Flutter builds, which iTMSTransporter rejects with status 409.
# Patch it to match the project's iOS deployment target before re-signing.
if [ -z "${MIN_IOS_VERSION:-}" ]; then
  MIN_IOS_VERSION=$(grep -m1 -oE 'IPHONEOS_DEPLOYMENT_TARGET = [0-9.]+' ios/Runner.xcodeproj/project.pbxproj | grep -oE '[0-9.]+$' || true)
fi
MIN_IOS_VERSION=${MIN_IOS_VERSION:-15.0}
APP_FRAMEWORK_PLIST="$ARCHIVE_PATH/Products/Applications/Runner.app/Frameworks/App.framework/Info.plist"
if [ -f "$APP_FRAMEWORK_PLIST" ]; then
  CURRENT=$(/usr/libexec/PlistBuddy -c "Print :MinimumOSVersion" "$APP_FRAMEWORK_PLIST" 2>/dev/null || echo "")
  if [ -z "$CURRENT" ] || [ "$CURRENT" = "(null)" ]; then
    echo "[export_signed_ipa] Patching empty MinimumOSVersion -> $MIN_IOS_VERSION in App.framework/Info.plist"
    /usr/libexec/PlistBuddy -c "Delete :MinimumOSVersion" "$APP_FRAMEWORK_PLIST" 2>/dev/null || true
    /usr/libexec/PlistBuddy -c "Add :MinimumOSVersion string $MIN_IOS_VERSION" "$APP_FRAMEWORK_PLIST"
  else
    echo "[export_signed_ipa] App.framework MinimumOSVersion already set: $CURRENT"
  fi
else
  echo "[export_signed_ipa] WARN: App.framework/Info.plist not found at expected path - skipping patch"
fi

echo "[export_signed_ipa] Exporting signed IPA (xcodebuild -exportArchive)"
EXPORT_DIR="build/ios/ipa"
rm -rf "$EXPORT_DIR"
xcodebuild -exportArchive \
  -archivePath "$ARCHIVE_PATH" \
  -exportOptionsPlist ios/ExportOptions.plist \
  -exportPath "$EXPORT_DIR"

IPA_PATH=$(find "$EXPORT_DIR" -name "*.ipa" | head -1 || true)
if [ -z "$IPA_PATH" ] || [ ! -f "$IPA_PATH" ]; then
  echo "[ERROR] xcodebuild -exportArchive did not produce an .ipa"
  ls -la "$EXPORT_DIR" || true
  exit 1
fi

# Rename to a deterministic path so downstream steps can reference a concrete
# filename - the upload actions do not glob.
STABLE_IPA="$EXPORT_DIR/app-release.ipa"
if [ "$IPA_PATH" != "$STABLE_IPA" ]; then
  mv "$IPA_PATH" "$STABLE_IPA"
fi
echo "[export_signed_ipa] Wrote signed IPA: $STABLE_IPA"
