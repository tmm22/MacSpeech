# Advanced Usage Guide

## Advanced Text Improvement Techniques

### 1. Optimizing Input Text
```text
Basic Input:
"The cat went to the store"

Better Input:
"The curious Siamese cat ventured to the local grocery store"

Why it's better:
- Provides more context
- Uses specific descriptors
- Maintains clear structure
```

### 2. Voice Selection Strategy

#### Content Type Matching
| Content Type | Recommended Voice | Why |
|--------------|------------------|-----|
| Business Reports | Onyx | Professional, authoritative tone |
| Children's Stories | Shimmer | Gentle, engaging quality |
| News Articles | Alloy | Neutral, clear delivery |
| Educational Content | Echo | Warm, instructional style |
| Creative Writing | Fable | Dynamic, expressive range |
| Marketing Copy | Nova | Energetic, persuasive tone |

#### Multi-Voice Projects
For longer content with different sections:
1. Use Alloy for introductions
2. Switch to Echo for main content
3. Use Nova for calls-to-action
4. Use Onyx for technical sections

### 3. Advanced Settings Usage

#### Debug Logging Patterns
```text
Success Pattern:
[12:34:56] ✅ API request successful
[12:34:57] ✅ Text improved successfully
[12:34:58] ✅ Speech generated successfully

Error Pattern:
[12:34:56] ❌ API error: rate limit exceeded
[12:34:57] ❌ Network timeout
```

#### API Usage Optimization
1. **Batch Processing**
   - Combine related text segments
   - Process during off-peak hours
   - Monitor token usage in debug logs

2. **Error Recovery**
   - Save improved text frequently
   - Keep original text as backup
   - Use debug logs for troubleshooting

### 4. Power User Workflows

#### Content Creation Workflow
1. **Draft Phase**
   - Write rough content
   - Use bullet points
   - Focus on key messages

2. **Improvement Phase**
   - Process text in sections
   - Review and adjust improvements
   - Maintain consistent style

3. **Audio Production**
   - Test with different voices
   - Record final versions
   - Archive audio files

#### Quality Assurance Workflow
1. **Text Verification**
   - Check improved text accuracy
   - Verify terminology
   - Ensure tone consistency

2. **Audio Review**
   - Listen for pronunciation
   - Check pacing
   - Verify emphasis points

### 5. Integration Examples

#### With Note-Taking Apps
```applescript
# Example AppleScript
tell application "Notes"
    set noteContent to text of first note
    # Copy to MacSpeechApp
end tell
```

#### With Text Editors
```bash
# Example shell command
pbpaste | open -a MacSpeechApp
```

### 6. Performance Tips

#### Memory Management
- Restart after processing large volumes
- Clear debug logs regularly
- Monitor system resources

#### Network Optimization
- Use wired connection when possible
- Process larger texts during stable connection
- Monitor API response times

### 7. Customization Examples

#### Text Improvement Patterns
```text
Academic:
"Based on recent studies..." → More formal, citation-ready

Creative:
"Once upon a time..." → More descriptive, engaging

Technical:
"The system processes..." → More precise, technical
```

#### Voice Combinations
1. **Presentation Format**
   - Intro: Nova (energetic)
   - Content: Echo (clear)
   - Summary: Onyx (authoritative)

2. **Story Format**
   - Narration: Fable
   - Dialog: Mix of Alloy and Echo
   - Description: Shimmer

### 7. Keyboard Shortcuts

#### Main Actions
```text
⌘I - Improve Text
⌘P - Play Speech
⌘⇧C - Copy Improved Text (Command + Shift + C)
⎋ - Close Settings Panel (Escape)
```

#### Configuration
1. **Enable/Disable**
   - Settings > UI Customization
   - Toggle "Enable Keyboard Shortcuts"
   - Affects all shortcuts when disabled

2. **Use Cases**
   - Quick text improvement
   - Rapid speech playback
   - Efficient text copying
   - Fast settings access

3. **Best Practices**
   - Learn common shortcuts
   - Use with auto-copy feature
   - Combine with word highlighting
   - Enable for power usage

### 8. Troubleshooting Advanced Issues

#### API Integration
```text
Issue: Rate Limiting
Solution: Implement exponential backoff
Status: Check debug logs for "Rate limit exceeded"
```

#### Audio Processing
```text
Issue: Audio Quality
Solution: Check system sample rate
Status: Monitor audio output settings
```

### 9. Best Practices

#### Text Processing
- Break long content into 2-3 paragraph chunks
- Maintain consistent formatting
- Use appropriate punctuation

#### Audio Generation
- Test voices before final selection
- Monitor audio file sizes
- Archive important outputs

### Need More Help?
- [Submit feature requests](https://github.com/tmm22/MacSpeech/issues/new?template=feature_request.md)
- [Report bugs](https://github.com/tmm22/MacSpeech/issues/new?template=bug_report.md)
- [View documentation](index.md) 