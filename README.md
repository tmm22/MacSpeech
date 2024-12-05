# MacSpeechApp

A macOS application that improves text using OpenAI's GPT models and can convert the improved text to speech using OpenAI's Text-to-Speech API.

## Features

- Text improvement using GPT models
- Text-to-speech conversion with multiple voice options
- Speech-to-text transcription with microphone
- Dark mode support with persistent preferences
- Clean, native macOS interface
- Real-time processing status indicators
- Debug logging support
- Configurable API settings
- Robust error handling and user feedback
- Proper permission management
- GitHub integration for community involvement

## Core Capabilities

### Text Processing
- Smart text improvement using GPT
- Multiple model options (GPT-4, GPT-3.5)
- Real-time processing indicators
- Error handling and recovery

### Speech Features
- Text-to-speech with multiple voices
- Speech-to-text transcription
- Microphone permission management
- Clear audio status feedback

### User Interface
- Dark mode support
- Native macOS design
- Intuitive settings panel
- Permission request handling
- Clear error messaging
- Progress indicators

### Development
- GitHub integration
- Comprehensive documentation
- Debug logging
- Community contribution support

## Requirements

- macOS 11.0 or later
- OpenAI API key
- Microphone access for speech-to-text
- Internet connection

## Installation

1. Download the latest release
2. Open the DMG file
3. Drag MacSpeechApp to your Applications folder
4. Launch the app and enter your OpenAI API key in settings

## Usage

1. Enter your text in the input field or use speech-to-text
2. Click "Improve" to enhance the text using GPT
3. Once improved, you can:
   - Copy the improved text
   - Select a voice and click the speaker button to hear it read aloud
   - Use speech-to-text for new input
4. Customize your experience:
   - Toggle dark mode in settings
   - Choose from multiple voice options
   - Enable debug logging for troubleshooting
   - Configure API settings

## Available Voices

- Alloy: Neutral and balanced
- Echo: Warm and conversational
- Fable: Authoritative and clear
- Onyx: Deep and resonant
- Nova: Energetic and bright
- Shimmer: Gentle and soothing

## Building from Source

1. Clone the repository
2. Make sure you have Xcode installed
3. Run `./build.sh` to build the application
4. Find the built app in `.build/release/MacSpeechApp.app`

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for detailed release notes and version history.

## License

MIT License 