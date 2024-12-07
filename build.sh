#!/bin/bash
set -e

APP_NAME="MacSpeechApp"
BUILD_DIR=".build/release"
APP_BUNDLE="$APP_NAME.app"
CONTENTS_DIR="$BUILD_DIR/$APP_BUNDLE/Contents"
MACOS_DIR="$CONTENTS_DIR/MacOS"
RESOURCES_DIR="$CONTENTS_DIR/Resources"
FRAMEWORKS_DIR="$CONTENTS_DIR/Frameworks"

echo "📦 Cleaning previous build..."
rm -rf "$BUILD_DIR/$APP_BUNDLE"
swift package clean

echo "📦 Building application..."
swift build -c release

echo "📦 Creating application bundle..."
mkdir -p "$MACOS_DIR"
mkdir -p "$RESOURCES_DIR"
mkdir -p "$FRAMEWORKS_DIR"

# Copy executable
cp "$BUILD_DIR/$APP_NAME" "$MACOS_DIR/"

# Copy Info.plist to correct location
cp Resources/Info.plist "$CONTENTS_DIR/Info.plist"

# Copy and ensure version.txt is readable
cp version.txt "$RESOURCES_DIR/version.txt"
chmod 644 "$RESOURCES_DIR/version.txt"

# Copy other resources
if [ -d "Resources" ]; then
    for file in Resources/*; do
        if [ "$(basename "$file")" != "Info.plist" ]; then
            cp -r "$file" "$RESOURCES_DIR/"
        fi
    done
fi

echo "📦 Creating DMG..."
DMG_DIR="Build"
rm -rf "$DMG_DIR"
mkdir -p "$DMG_DIR/tmp"

# Copy app bundle to DMG directory
cp -r "$BUILD_DIR/$APP_BUNDLE" "$DMG_DIR/tmp/"

# Create Applications symlink
ln -s /Applications "$DMG_DIR/tmp/Applications"

# Create DMG
hdiutil create -volname "$APP_NAME" -srcfolder "$DMG_DIR/tmp" -ov -format UDZO "$DMG_DIR/$APP_NAME.dmg"

# Cleanup
rm -rf "$DMG_DIR/tmp"

echo "✅ Build completed successfully!"
echo "📦 App bundle created at: $BUILD_DIR/$APP_BUNDLE"
echo "📦 DMG installer created at: $DMG_DIR/$APP_NAME.dmg"