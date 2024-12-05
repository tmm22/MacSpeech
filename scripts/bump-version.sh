#!/bin/bash

# Function to increment version
increment_version() {
  local version=$1
  local release_type=$2
  
  # Split version into major, minor, patch
  IFS='.' read -r -a version_parts <<< "$version"
  local major="${version_parts[0]}"
  local minor="${version_parts[1]}"
  local patch="${version_parts[2]}"
  
  case $release_type in
    major)
      major=$((major + 1))
      minor=0
      patch=0
      ;;
    minor)
      minor=$((minor + 1))
      patch=0
      ;;
    patch)
      patch=$((patch + 1))
      ;;
    *)
      echo "Invalid release type. Use: major, minor, or patch"
      exit 1
      ;;
  esac
  
  echo "${major}.${minor}.${patch}"
}

# Check if release type is provided
if [ $# -ne 1 ]; then
  echo "Usage: $0 <major|minor|patch>"
  exit 1
fi

RELEASE_TYPE=$1
CURRENT_VERSION=$(cat version.txt)
NEW_VERSION=$(increment_version "$CURRENT_VERSION" "$RELEASE_TYPE")

# Update version.txt
echo "$NEW_VERSION" > version.txt

# Update Info.plist version
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $NEW_VERSION" Resources/Info.plist
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $NEW_VERSION" Resources/Info.plist

# Create git tag with release notes template
RELEASE_NOTES=$(cat << EOF
feat: Release version $NEW_VERSION

Key changes in this release:
- 

For a full list of changes, see the changelog.
EOF
)

# Create git tag
git add version.txt Resources/Info.plist
git commit -m "$RELEASE_NOTES"
git tag -a "v$NEW_VERSION" -m "Release version $NEW_VERSION"

echo "Version bumped to $NEW_VERSION"
echo ""
echo "Next steps:"
echo "1. Edit the commit message to add release notes"
echo "2. Run 'git push && git push --tags' to publish"
echo ""
echo "Commit message format for better changelogs:"
echo "feat: Add new feature"
echo "fix: Fix a bug"
echo "docs: Update documentation"
echo "chore: Maintenance work"
echo "perf: Performance improvements" 