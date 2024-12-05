---
layout: default
title: Debug Logging
---

# Debug Logging

## Overview
Debug logging provides detailed information about the application's operation, API interactions, and potential issues. This feature is essential for troubleshooting, monitoring performance, and understanding the application's behavior.

## Enabling Debug Logs
1. Open Settings (⌘,)
2. Navigate to Debug section
3. Toggle "Show Debug Logs"
4. Logs appear in settings panel

## Log Components

### Basic Structure
```
[Timestamp] Level: Component - Message
Example:
[12:34:56] INFO: API - Request started
```

### Log Levels
| Level | Symbol | Description | Use Case |
|-------|---------|------------|-----------|
| INFO | ℹ️ | General information | Normal operations |
| SUCCESS | ✅ | Successful operations | Completed tasks |
| WARNING | ⚠️ | Potential issues | Minor problems |
| ERROR | ❌ | Operation failures | Critical issues |

### Logged Information

#### API Interactions
```
[12:34:56] ℹ️ API: Starting request to OpenAI
[12:34:57] ✅ API: Response received (200)
[12:34:57] ℹ️ API: Processing completed in 1.2s
```

#### Text Processing
```
[12:34:56] ℹ️ Text: Starting improvement
[12:34:57] ℹ️ Text: Using GPT-4 model
[12:34:58] ✅ Text: Improvement completed
```

#### Speech Operations
```
[12:34:56] ℹ️ Speech: Starting recording
[12:34:57] ✅ Speech: Recording completed
[12:34:58] ℹ️ Speech: Processing audio
```

## Using Debug Logs

### For Troubleshooting
1. Enable logging before issue occurs
2. Reproduce the problem
3. Check logs for errors
4. Note relevant messages

### For Monitoring
- Watch processing times
- Track API usage
- Monitor error rates
- Identify patterns

### For Development
- Track feature usage
- Identify bottlenecks
- Debug integration issues
- Verify functionality

## Common Log Patterns

### Successful Operation
```
[12:34:56] ℹ️ Starting operation
[12:34:57] ℹ️ Processing step 1
[12:34:58] ℹ️ Processing step 2
[12:34:59] ✅ Operation completed
```

### Error Condition
```
[12:34:56] ℹ️ Starting operation
[12:34:57] ⚠️ Warning: Slow response
[12:34:58] ❌ Error: Operation failed
[12:34:59] ℹ️ Attempting retry
```

### API Interaction
```
[12:34:56] ℹ️ API: Preparing request
[12:34:57] ℹ️ API: Request sent
[12:34:58] ✅ API: Response received
[12:34:59] ℹ️ API: Processing complete
```

## Best Practices

### Log Management
- Clear logs periodically
- Save important logs
- Monitor log size
- Focus on relevant information

### Troubleshooting
- Enable logs before testing
- Note exact time of issues
- Look for error patterns
- Check surrounding context

### Performance Monitoring
- Track response times
- Monitor success rates
- Watch for warnings
- Note resource usage

## Advanced Usage

### Log Analysis
```python
Common Patterns:
1. API Timeouts:
   [TIME] ⚠️ API: Slow response
   [TIME] ❌ API: Request timeout

2. Rate Limiting:
   [TIME] ❌ API: Rate limit exceeded
   [TIME] ℹ️ API: Retrying in 60s

3. Success Patterns:
   [TIME] ℹ️ Start -> ✅ Complete
   [TIME] Multiple ℹ️ steps -> ✅ Result
```

### Performance Metrics
- Average response time
- Success/failure ratio
- API call frequency
- Error distribution

## Troubleshooting

1. **Problem**: Logs Not Appearing
   Solution:
   - Verify debug mode enabled
   - Check settings panel
   - Restart application
   - Clear existing logs

2. **Problem**: Too Many Logs
   Solution:
   - Clear old logs
   - Focus on specific operations
   - Filter by log level
   - Export and clear

3. **Problem**: Missing Information
   Solution:
   - Enable detailed logging
   - Reproduce issue
   - Check all log levels
   - Verify timing

## Integration with Other Features

### With Text Improvement
- Monitor processing time
- Track model usage
- Verify improvements
- Debug quality issues

### With Speech Features
- Track audio processing
- Monitor transcription
- Debug permission issues
- Verify voice selection

## Related Features
- [Settings Guide](settings.md)
- [Text Improvement](text-improvement.md)
- [Speech-to-Text](speech-to-text.md)

## Further Reading
- [OpenAI API Documentation](https://platform.openai.com/docs)
- [macOS Console App Guide](https://support.apple.com/guide/console)
- [Advanced Usage Guide](../advanced-usage.md) 