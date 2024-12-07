---
layout: default
title: Check for Updates
---

# Check for Updates

## Overview
MacSpeechApp includes an automatic update checker that helps you stay current with the latest version. The app checks for updates when launched and allows manual checks through the settings panel.

## Features

### Automatic Update Check
- Runs when the app launches
- Compares your version with the latest GitHub release
- Shows notification if update is available
- Non-intrusive and runs in background

### Manual Update Check
- Available in Settings > Updates
- Shows current version
- Displays update status
- Provides direct download link

## Update Information Display

### Version Information
- Current Version: Shows your installed version
- Latest Version: Shows newest available version (when checked)
- Status Indicator: Shows if you're up to date

### Status Messages
- "Up to date": Your version matches the latest
- "New version available": An update is available
- "Checking...": Update check in progress

## How to Check for Updates

1. **Automatic Check**
   - Launch the app
   - Status appears in Settings > Updates
   - Notification shows if update available

2. **Manual Check**
   - Open Settings (gear icon)
   - Navigate to Updates section
   - Click "Check for Updates"
   - Wait for status to update

3. **Download Updates**
   - If update available, click "Download Update"
   - Opens GitHub releases page
   - Download latest .dmg file
   - Install as usual

## Update Process

### Checking for Updates
1. App contacts GitHub API
2. Retrieves latest release information
3. Compares versions
4. Updates status display

### Installing Updates
1. Download new version
2. Close current app
3. Open downloaded .dmg
4. Drag to Applications
5. Replace existing version

## Best Practices

### When to Update
- When new features are needed
- For bug fixes
- For security updates
- When prompted by the app

### Before Updating
- Save any work in progress
- Note your current settings
- Back up custom prompts
- Close the application

## Troubleshooting

### Common Issues

1. **Update Check Fails**
   - Check internet connection
   - Try manual check
   - Verify GitHub access
   - Wait and try again

2. **Version Mismatch**
   - Restart the app
   - Check current version in settings
   - Perform manual update check
   - Reinstall if needed

3. **Download Issues**
   - Try different browser
   - Check download permissions
   - Verify disk space
   - Use direct GitHub link

## Configuration

### Update Settings
- Located in Settings panel
- Shows version information
- Provides update controls
- Displays check status

### Update Notifications
- Non-intrusive
- Show in settings
- Include version numbers
- Provide direct links

## Technical Details

### Version Checking
```swift
// Version comparison logic
let latestComponents = latest.split(separator: ".")
let currentComponents = current.split(separator: ".")
updateAvailable = latestNum > currentNum
```

### Update Sources
- GitHub Releases API
- Official release packages
- Signed DMG files
- Version-tagged releases

## Related Features
- [Settings Management](settings.md)
- [Custom Prompts](custom-prompts.md)
- [Debug Logging](debug-logging.md)

## Further Reading
- [GitHub Release Documentation](https://docs.github.com/en/repositories/releasing-projects-on-github)
- [macOS App Updates Best Practices](https://developer.apple.com/app-store/app-updates/)
- [Contribution Guide](../contribution-guide.md) 