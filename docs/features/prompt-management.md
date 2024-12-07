---
layout: default
title: Prompt Management
---

# Prompt Management

## Overview
MacSpeechApp allows you to create, save, import, and export custom prompts. This feature enables you to back up your prompts, share them with others, or transfer them between different installations.

## Managing Custom Prompts

### Creating Custom Prompts
1. Open Settings (gear icon)
2. Navigate to "Custom Prompts Management"
3. Enable "Use Custom Prompt"
4. Enter your prompt in the text editor
5. Click "Save as Preset" to store it

### Using Example Prompts
1. Click "Select Example Prompt"
2. Choose from available templates:
   - Professional Writing
   - Creative Writing
   - Technical Documentation
   - Academic Writing
   - And many more...
3. Modify as needed
4. Save as a preset if desired

## Import/Export Functionality

### Exporting Prompts
1. In the Custom Prompts section
2. Click "Export Prompts" (up arrow icon)
3. Choose save location
4. Default filename: "custom_prompts.json"
5. All saved prompts will be exported

### Importing Prompts
1. In the Custom Prompts section
2. Click "Import Prompts" (down arrow icon)
3. Select a previously exported JSON file
4. Prompts will be added to your existing collection
5. Duplicates are automatically handled

### File Format
The exported JSON file contains an array of prompts:
```json
[
  "You are a professional writing assistant...",
  "You are a creative writing enhancer...",
  "Custom prompt 1...",
  "Custom prompt 2..."
]
```

## Best Practices

### Organizing Prompts
- Use clear, descriptive prompts
- Test prompts before saving
- Remove unused prompts
- Keep backups of important prompts

### Sharing Prompts
1. Export your prompts
2. Share the JSON file
3. Recipients can import using their app
4. Prompts maintain formatting

### Backup Strategy
- Regular exports for backup
- Store in cloud storage
- Keep multiple versions
- Test restored prompts

## Troubleshooting

### Import Issues
1. Verify file format (must be JSON)
2. Check file permissions
3. Ensure file isn't corrupted
4. Try re-exporting if needed

### Export Issues
1. Check write permissions
2. Verify disk space
3. Try different save location
4. Ensure prompts are saved

## Tips & Tricks

### Prompt Management
- Export before major changes
- Import to test integrity
- Use version numbers in filenames
- Keep documentation of custom prompts

### Collaboration
- Share prompt collections
- Document prompt purposes
- Test shared prompts
- Maintain style consistency

### Security
- Review imported prompts
- Backup sensitive prompts
- Don't share API keys
- Validate unknown sources

## Technical Details

### File Structure
- Format: JSON
- Encoding: UTF-8
- File extension: .json
- Array structure

### Storage
- Local UserDefaults storage
- JSON export format
- Maintains prompt integrity
- Preserves formatting

### Compatibility
- Cross-version support
- Platform independent
- Maintains structure
- Preserves metadata

## Related Features
- [Custom Prompts](custom-prompts.md)
- [Settings Management](settings.md)
- [Text Improvement](text-improvement.md)

## Further Reading
- [Advanced Usage Guide](../advanced-usage.md)
- [Contribution Guide](../contribution-guide.md)
- [FAQ](../faq.md) 