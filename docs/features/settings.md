---
layout: default
title: Settings and Configuration
---

# Settings and Configuration

## Overview
The Settings panel in MacSpeechApp provides comprehensive control over the application's behavior, appearance, and API configuration. This guide covers all available settings and how to use them effectively.

## Accessing Settings
- Click the gear icon ⚙️ in the top-right corner
- Use keyboard shortcut ⌘, (Command + Comma)
- Settings panel opens as a modal sheet

## Settings Categories

### API Settings
| Setting | Description | Default | Notes |
|---------|-------------|---------|--------|
| OpenAI API Key | Your API authentication key | None | Required for all features |
| Save API Key | Stores key securely | N/A | Uses system keychain |

#### Configuration Steps
1. Get API key from [OpenAI Platform](https://platform.openai.com)
2. Enter key in API Key field
3. Click "Save API Key"
4. Verify connection in debug logs

### Model Selection
| Setting | Description | Default | Notes |
|---------|-------------|---------|--------|
| GPT Model | Choose between available models | GPT-3.5-turbo | Affects cost and quality |
| Model List | Available models from API | Dynamic | Updates automatically |

#### Model Comparison
- **GPT-4**
  - Highest quality
  - Best for critical content
  - Slower processing
  - Higher cost

- **GPT-3.5-turbo**
  - Good quality
  - Fast processing
  - Cost-effective
  - Best for general use

### Appearance
| Setting | Description | Default | Notes |
|---------|-------------|---------|--------|
| Dark Mode | Toggle dark/light theme | System | Persists between sessions |
| Theme | Visual style settings | System | Follows macOS settings |
| Auto-Copy | Automatically copy improved text | Off | Copies to clipboard |

#### Dark Mode Benefits
- Reduced eye strain
- Better for low-light environments
- Professional appearance
- System integration

#### Auto-Copy Features
- Automatic clipboard update
- Immediate availability
- System integration
- Workflow optimization
- Silent operation

### Debug Settings
| Setting | Description | Default | Notes |
|---------|-------------|---------|--------|
| Show Debug Logs | Display technical information | Off | Helpful for troubleshooting |
| Log Level | Detail level of logging | Info | More detail = slower performance |

#### Debug Information
- API calls and responses
- Processing times
- Error messages
- System status

## Best Practices

### API Key Management
- Never share your API key
- Rotate keys periodically
- Monitor usage in OpenAI dashboard
- Save backup of key securely

### Model Selection
- Use GPT-3.5 for drafts
- Switch to GPT-4 for final versions
- Monitor costs in OpenAI dashboard
- Test different models for your needs

### Performance Optimization
- Clear debug logs regularly
- Use appropriate model for task
- Monitor system resources
- Close settings when not needed

#### Auto-Copy Management
- Enable for repetitive tasks
- Disable for sensitive content
- Monitor clipboard usage
- Clear clipboard when needed
- Use with system features

## Troubleshooting

1. **Problem**: API Key Not Saving
   Solution:
   - Check internet connection
   - Verify key format
   - Try re-entering key
   - Check system keychain access

2. **Problem**: Models Not Loading
   Solution:
   - Verify API key
   - Check internet connection
   - Restart application
   - Clear debug logs

3. **Problem**: Settings Not Persisting
   Solution:
   - Check disk permissions
   - Verify user preferences access
   - Reset app preferences
   - Reinstall if necessary

## Advanced Configuration

### Debug Log Analysis
```
API Call Success:
[12:34:56] ✅ Model loaded successfully
[12:34:57] ✅ Text processed in 2.3s
[12:34:58] ℹ️ Using GPT-4 model

API Error:
[12:34:56] ❌ API key invalid
[12:34:57] ❌ Network timeout
[12:34:58] ⚠️ Retrying request
```

### Performance Monitoring
- Watch processing times
- Monitor API usage
- Track error rates
- Analyze response times

## Integration with Other Features

### With Text Improvement
- Select appropriate model
- Monitor processing in debug logs
- Track improvement quality
- Adjust based on results

### With Speech Features
- Configure for optimal quality
- Monitor processing times
- Adjust based on usage patterns
- Track error rates

## Related Features
- [Text Improvement](text-improvement.md)
- [Text-to-Speech](text-to-speech.md)
- [Speech-to-Text](speech-to-text.md)

## Further Reading
- [OpenAI API Documentation](https://platform.openai.com/docs)
- [macOS Settings Guidelines](https://developer.apple.com/design/human-interface-guidelines/settings)
- [Advanced Usage Guide](../advanced-usage.md) 