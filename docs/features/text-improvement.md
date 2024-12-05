---
layout: default
title: Text Improvement
---

# Text Improvement

## Overview
The Text Improvement feature uses OpenAI's GPT models to enhance your text while maintaining its original meaning. It can improve clarity, style, grammar, and overall readability. This feature is perfect for writing, editing, content creation, and ensuring professional communication.

## Requirements
- macOS 11.0 or later
- OpenAI API key
- Internet connection
- GPT model access (GPT-4 or GPT-3.5)

## Basic Usage
1. **Enter Text**
   - Type or paste your text in the input field
   - No length limit, but consider processing in chunks for best results
   - Original formatting is preserved

2. **Select Model** (in Settings)
   - GPT-4: Best quality, slower, more expensive
   - GPT-3.5: Faster, more economical, good for most uses

3. **Improve Text**
   - Click the "Improve Text" button
   - Wait for processing (time varies by length)
   - Review improved text in output field

## Configuration
| Option | Description | Default | Location |
|--------|-------------|---------|-----------|
| GPT Model | Choose AI model | GPT-3.5 | Settings > Model Selection |
| Debug Logging | Show API interactions | Off | Settings > Debug |
| API Key | Your OpenAI key | None | Settings > API Settings |

## Advanced Usage
- **Content-Based Model Selection**
  ```
  Critical Content:
  - Use GPT-4 for:
    - Legal documents
    - Technical writing
    - Professional publications
  
  Regular Content:
  - Use GPT-3.5 for:
    - Daily communications
    - Draft improvements
    - Quick edits
  ```

- **Batch Processing**
  ```
  1. Split long content into sections
  2. Process each section
  3. Review and combine
  4. Final pass on complete text
  ```

## Best Practices
- Review improved text carefully
- Use appropriate model for content type
- Keep sections reasonable in length
- Enable debug logging for important content
- Save original text before processing
- Process important content in sections
- Use with speech-to-text for natural flow

## Troubleshooting
1. **Problem**: Slow Processing
   Solution:
   - Check internet connection
   - Use smaller text chunks
   - Try GPT-3.5 for drafts
   - Clear debug logs

2. **Problem**: Quality Issues
   Solution:
   - Switch to GPT-4
   - Provide clearer input
   - Process in smaller sections
   - Review and reprocess if needed

3. **Problem**: API Errors
   Solution:
   - Verify API key
   - Check OpenAI status
   - Confirm account credits
   - Review error messages in debug log

## Examples
1. **Business Email**
   ```
   Original:
   "Hey want to meet about the project tomorrow?"

   Improved:
   "I would like to schedule a meeting to discuss the project tomorrow. What time works best for you?"
   ```

2. **Technical Document**
   ```
   Original:
   "The system uses AI to make text better."

   Improved:
   "The system leverages advanced artificial intelligence algorithms to enhance text quality and clarity."
   ```

3. **Creative Writing**
   ```
   Original:
   "The old house was scary and dark."

   Improved:
   "The dilapidated mansion loomed ominously, its shadowy facade concealing decades of neglect."
   ```

## Improvement Strategies

### Professional Content
- Use GPT-4
- Focus on clarity and precision
- Maintain formal tone
- Preserve technical terms
- Ensure consistent style

### Creative Content
- Enhance descriptive language
- Maintain author's voice
- Improve flow and pacing
- Strengthen imagery
- Keep emotional impact

### Academic Content
- Maintain scholarly tone
- Improve structure
- Enhance clarity
- Preserve citations
- Strengthen arguments

### Casual Content
- Keep natural tone
- Improve clarity
- Fix grammar/spelling
- Maintain personality
- Enhance readability

## Integration Tips
1. **With Speech-to-Text**
   - Record thoughts naturally
   - Improve transcribed text
   - Review and refine
   - Use text-to-speech to verify

2. **With Text-to-Speech**
   - Improve text first
   - Listen to results
   - Identify areas for refinement
   - Final improvement pass

## Related Features
- [Text-to-Speech](text-to-speech.md)
- [Speech-to-Text](speech-to-text.md)
- [Settings Guide](settings.md)

## Further Reading
- [OpenAI GPT Documentation](https://platform.openai.com/docs/guides/gpt)
- [Writing Best Practices](../advanced-usage.md#writing-best-practices)
- [Content Creation Guide](../advanced-usage.md#content-creation) 