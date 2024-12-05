---
layout: default
title: Text-to-Speech
---

# Text-to-Speech

## Overview
The Text-to-Speech feature converts written text into natural-sounding speech using OpenAI's advanced speech synthesis technology. With multiple voice options and high-quality output, it's perfect for proofreading, accessibility, content creation, or learning pronunciation.

## Requirements
- macOS 11.0 or later
- OpenAI API key
- Internet connection
- System audio output

## Basic Usage
1. **Prepare Text**
   - Enter or paste text in the input field
   - Optionally use the "Improve" feature first
   - Select the text you want to convert (or use all)

2. **Select Voice**
   - Choose from the voice dropdown menu:
     - Alloy: Neutral and balanced (best for general use)
     - Echo: Warm and conversational (great for dialogue)
     - Fable: Authoritative and clear (perfect for presentations)
     - Onyx: Deep and resonant (ideal for formal content)
     - Nova: Energetic and bright (good for engaging content)
     - Shimmer: Gentle and soothing (best for narrative)

3. **Generate Speech**
   - Click the speaker button
   - Wait for processing (usually 2-3 seconds)
   - Audio will play automatically

## Configuration
| Option | Description | Default | Location |
|--------|-------------|---------|-----------|
| Voice Selection | Choose voice style | Alloy | Main interface |
| Debug Logging | Show API interactions | Off | Settings > Debug |
| System Volume | Control playback volume | System default | System controls |

## Advanced Usage
- **Content-Based Voice Selection**
  ```
  Business Report:
  - Use Onyx for executive summaries
  - Use Alloy for detailed sections
  - Use Fable for conclusions
  
  Creative Content:
  - Use Echo for character dialogue
  - Use Nova for action sequences
  - Use Shimmer for descriptions
  ```

- **Multi-Voice Projects**
  ```
  1. Split text by section/character
  2. Process each with appropriate voice
  3. Use debug logs to track processing
  4. Combine in your preferred audio editor
  ```

## Best Practices
- Choose voice based on content type
- Keep paragraphs reasonably sized
- Use proper punctuation for natural pauses
- Test different voices for best results
- Consider your target audience
- Use improved text for better pronunciation

## Troubleshooting
1. **Problem**: No audio output
   Solution:
   - Check system volume
   - Verify audio output device
   - Check internet connection
   - Restart the app

2. **Problem**: Poor pronunciation
   Solution:
   - Use proper punctuation
   - Try different voices
   - Use the text improvement feature
   - Break complex sentences

3. **Problem**: Slow processing
   Solution:
   - Check internet speed
   - Reduce text length
   - Clear debug logs
   - Process in smaller chunks

## Examples
1. **Business Presentation**
   ```
   - Use Onyx voice
   - Process each slide separately
   - Add proper punctuation
   - Test in presentation environment
   ```

2. **Creative Writing**
   ```
   - Use Echo for dialogue
   - Use Shimmer for narration
   - Process chapter by chapter
   - Review with text visible
   ```

3. **Educational Content**
   ```
   - Use Fable for instructions
   - Use Nova for examples
   - Include pronunciation marks
   - Test with target audience
   ```

## Voice Selection Guide

### Alloy
- **Best for**: General content, documentation, emails
- **Characteristics**: Neutral, clear, professional
- **Use when**: You need a versatile, balanced voice

### Echo
- **Best for**: Conversational content, dialogue, informal content
- **Characteristics**: Warm, friendly, engaging
- **Use when**: You want a natural, approachable tone

### Fable
- **Best for**: Presentations, tutorials, formal content
- **Characteristics**: Authoritative, clear, instructional
- **Use when**: You need to convey expertise and authority

### Onyx
- **Best for**: Executive content, formal announcements, serious topics
- **Characteristics**: Deep, resonant, commanding
- **Use when**: You need maximum gravitas and authority

### Nova
- **Best for**: Marketing, enthusiastic content, calls to action
- **Characteristics**: Energetic, bright, motivating
- **Use when**: You want to energize and engage

### Shimmer
- **Best for**: Storytelling, meditation content, gentle instruction
- **Characteristics**: Soft, soothing, calming
- **Use when**: You need a gentle, approachable tone

## Related Features
- [Text Improvement](text-improvement.md)
- [Speech-to-Text](speech-to-text.md)
- [Debug Logging](debug-logging.md)

## Further Reading
- [OpenAI TTS Documentation](https://platform.openai.com/docs/guides/text-to-speech)
- [Voice Selection Strategies](../advanced-usage.md#voice-selection-strategy)
- [Content Creation Guide](../advanced-usage.md#content-creation) 