---
layout: default
title: Speech-to-Text
---

# Speech-to-Text

## Overview
The Speech-to-Text feature allows you to convert spoken words into text using your device's microphone. This feature is perfect for users who prefer dictation over typing, need to transcribe audio content, or have accessibility requirements.

## Requirements
- macOS 11.0 or later
- Microphone access permission
- OpenAI API key (for transcription service)
- Internet connection

## Basic Usage
1. **Grant Permissions**
   - When first using the feature, you'll be prompted for microphone access
   - Click "Request Permissions" when prompted
   - Approve the permission in System Settings if needed

2. **Record Speech**
   - Click the microphone button in the input section
   - Speak clearly into your microphone
   - Click the button again to stop recording

3. **Review Transcription**
   - The transcribed text will appear in the input field
   - Edit the text if needed
   - Click "Improve" to enhance the transcribed text

## Configuration
| Option | Description | Default | Location |
|--------|-------------|---------|-----------|
| Microphone Permission | Enable/disable microphone access | Not granted | System Settings > Privacy |
| Debug Logging | Show detailed logs for troubleshooting | Off | Settings > Debug |

## Advanced Usage
- **Long-form Dictation**
  ```
  1. Enable debug logging for detailed feedback
  2. Record in shorter segments (30-60 seconds)
  3. Use the improve function for each segment
  4. Combine improved segments
  ```

- **Integration with Text Improvement**
  ```
  1. Record speech
  2. Review transcription
  3. Click improve for enhanced text
  4. Use text-to-speech to verify output
  ```

## Best Practices
- Speak clearly and at a moderate pace
- Use proper punctuation words ("period", "comma", "new paragraph")
- Record in a quiet environment
- Keep microphone at a consistent distance
- Break long content into smaller segments

## Troubleshooting
1. **Problem**: App doesn't detect microphone
   Solution: 
   - Check System Settings > Privacy > Microphone
   - Ensure MacSpeech is allowed
   - Restart the app after granting permission

2. **Problem**: Poor transcription quality
   Solution:
   - Reduce background noise
   - Speak more clearly
   - Position microphone closer
   - Use external microphone if available

3. **Problem**: Permission dialog doesn't appear
   Solution:
   - Click "Request Permissions" in the app
   - Reset privacy settings in System Settings
   - Reinstall app if issue persists

## Examples
1. **Basic Dictation**
   - Click record
   - Say: "This is a test of the speech to text feature period"
   - Click stop
   - Review transcribed text

2. **Professional Document**
   - Enable debug logging
   - Record in segments
   - Use improve function
   - Combine segments
   - Review and edit

3. **Mixed Input**
   - Type initial text
   - Add dictated sections
   - Improve combined text
   - Use text-to-speech for review

## Related Features
- [Text Improvement](text-improvement.md)
- [Text-to-Speech](text-to-speech.md)
- [Debug Logging](debug-logging.md)

## Further Reading
- [OpenAI Whisper Documentation](https://platform.openai.com/docs/guides/speech-to-text)
- [macOS Privacy Guidelines](https://support.apple.com/guide/mac-help/control-access-to-your-microphone-on-mac-mchla1b1bb1d/mac)
- [Advanced Usage Guide](../advanced-usage.md) 