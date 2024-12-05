#!/bin/bash

# Function to extract commits by type
extract_commits() {
    local type=$1
    local pattern=$2
    local commits=$3
    local matches=$(echo "$commits" | grep -i "^$pattern" || true)
    if [ ! -z "$matches" ]; then
        echo "### $type"
        echo ""
        echo "$matches" | sed -E "s/^$pattern[[:space:]]*/- /"
        echo ""
    fi
}

# Get the previous tag
PREVIOUS_TAG=$(git describe --tags --abbrev=0 HEAD^ 2>/dev/null || echo "")

if [ -z "$PREVIOUS_TAG" ]; then
    # If no previous tag exists, get all commits
    COMMITS=$(git log --pretty=format:"%s")
else
    # Get commits between tags
    COMMITS=$(git log --pretty=format:"%s" $PREVIOUS_TAG..HEAD)
fi

# Create changelog file
CHANGELOG_FILE="CHANGELOG.md"
VERSION=$(cat version.txt)

# Add header
echo "# Changelog" > $CHANGELOG_FILE
echo "" >> $CHANGELOG_FILE
echo "## Version $VERSION" >> $CHANGELOG_FILE
echo "" >> $CHANGELOG_FILE

# Extract different types of changes
extract_commits "🚀 New Features" "feat:|feature:|add:" "$COMMITS" >> $CHANGELOG_FILE
extract_commits "🐛 Bug Fixes" "fix:|bug:|patch:" "$COMMITS" >> $CHANGELOG_FILE
extract_commits "📝 Documentation" "docs:|doc:" "$COMMITS" >> $CHANGELOG_FILE
extract_commits "🔧 Maintenance" "chore:|refactor:|style:|test:" "$COMMITS" >> $CHANGELOG_FILE
extract_commits "⚡️ Performance" "perf:|optimize:" "$COMMITS" >> $CHANGELOG_FILE

# Add installation instructions
echo "## Installation" >> $CHANGELOG_FILE
echo "" >> $CHANGELOG_FILE
echo "1. Download MacSpeechApp.dmg" >> $CHANGELOG_FILE
echo "2. Open the DMG file" >> $CHANGELOG_FILE
echo "3. Drag MacSpeechApp to your Applications folder" >> $CHANGELOG_FILE
echo "4. Launch and enter your OpenAI API key" >> $CHANGELOG_FILE
echo "" >> $CHANGELOG_FILE

# Add requirements
echo "## Requirements" >> $CHANGELOG_FILE
echo "" >> $CHANGELOG_FILE
echo "- macOS 11.0 or later" >> $CHANGELOG_FILE
echo "- OpenAI API key" >> $CHANGELOG_FILE

echo "Changelog generated at $CHANGELOG_FILE" 
 