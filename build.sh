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

# Copy resources
if [ -d "Resources" ]; then
    cp -r Resources/* "$RESOURCES_DIR/"
fi

# Create Info.plist
cat > "$CONTENTS_DIR/Info.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>$APP_NAME</string>
    <key>CFBundleIdentifier</key>
    <string>com.example.$APP_NAME</string>
    <key>CFBundleName</key>
    <string>$APP_NAME</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.1.0</string>
    <key>CFBundleVersion</key>
    <string>1.1.0</string>
    <key>LSMinimumSystemVersion</key>
    <string>13.0</string>
    <key>LSApplicationCategoryType</key>
    <string>public.app-category.productivity</string>
    <key>LSUIElement</key>
    <false/>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>NSCameraUsageDescription</key>
    <string>MacSpeech requires camera access for audio session setup.</string>
    <key>NSMicrophoneUsageDescription</key>
    <string>MacSpeech needs access to your microphone to record speech for transcription.</string>
    <key>NSPrincipalClass</key>
    <string>NSApplication</string>
    <key>NSSpeechRecognitionUsageDescription</key>
    <string>MacSpeech needs access to speech recognition to transcribe your speech.</string>
    <key>CFBundleSupportedPlatforms</key>
    <array>
        <string>MacOSX</string>
    </array>
</dict>
</plist>
EOF

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