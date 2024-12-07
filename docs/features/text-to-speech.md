---
layout: default
title: Text-to-Speech
---

# Text-to-Speech

## Overview
MacSpeechApp offers two text-to-speech providers:
1. OpenAI's Text-to-Speech API (default)
2. ElevenLabs API (optional)

You can choose which provider to use in the settings panel.

## OpenAI Text-to-Speech
The default provider with high-quality voices and natural-sounding speech.

### Available Voices
- Alloy: Neutral and balanced
- Echo: Warm and conversational
- Fable: Authoritative and clear
- Onyx: Deep and resonant
- Nova: Energetic and bright
- Shimmer: Gentle and soothing

### Speed Control
- Range: 0.5x to 4.0x
- Default: 1.0x

## ElevenLabs Text-to-Speech
An optional provider offering additional voices and customization options.

### Setup
1. Get an API key from [ElevenLabs](https://elevenlabs.io)
2. Enter the key in Settings > API Settings
3. Enable "Use ElevenLabs for Text-to-Speech"

### Features
- Multiple professional voices
- Voice cloning capabilities (with ElevenLabs subscription)
- Advanced voice settings:
  - Stability
  - Similarity boost
  - Style control
  - Speaker boost

## Configuration

### API Settings
1. Open Settings (gear icon)
2. Navigate to API Settings
3. Enter your API key(s):
   - OpenAI API Key (required)
   - ElevenLabs API Key (optional)
4. Choose your preferred provider

### Voice Selection
1. Choose a voice from the dropdown
2. For OpenAI: Select speed (0.5x - 4.0x)
3. For ElevenLabs: Adjust voice settings if needed

## Usage

1. Enter or improve text
2. Select your preferred voice
3. Click the speaker button
4. Audio will play automatically

## Best Practices

### Text Preparation
- Break long text into paragraphs
- Use proper punctuation
- Consider voice-friendly formatting
- Test with different voices

### Voice Selection
- Match voice to content type
- Consider audience preferences
- Test different speeds
- Use appropriate provider

## Troubleshooting

### OpenAI Issues
1. Verify API key
2. Check internet connection
3. Confirm text length
4. Try different voice/speed

### ElevenLabs Issues
1. Verify API key
2. Check quota/limits
3. Test voice settings
4. Try different voices

## Related Features
- [Text Improvement](text-improvement.md)
- [Settings Guide](settings.md)
- [Debug Logging](debug-logging.md)

## Further Reading
- [OpenAI TTS Documentation](https://platform.openai.com/docs/guides/text-to-speech)
- [ElevenLabs Documentation](https://docs.elevenlabs.io/welcome/introduction)
- [Advanced Usage Guide](../advanced-usage.md) 