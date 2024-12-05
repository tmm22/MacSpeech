# MacSpeechApp

A macOS application that improves text using OpenAI's GPT models and can convert the improved text to speech using OpenAI's Text-to-Speech API.

## Features

- Text improvement using GPT models
- Text-to-speech conversion with multiple voice options
- Dark mode support with persistent preferences
- Clean, native macOS interface
- Real-time processing status indicators
- Debug logging support
- Configurable API settings

## Requirements

- macOS 11.0 or later
- OpenAI API key

## Installation

1. Download the latest release
2. Open the DMG file
3. Drag MacSpeechApp to your Applications folder
4. Launch the app and enter your OpenAI API key in settings

## Usage

1. Enter your text in the input field
2. Click "Improve" to enhance the text using GPT
3. Once improved, you can:
   - Copy the improved text
   - Select a voice and click the speaker button to hear it read aloud
4. Customize your experience:
   - Toggle dark mode in settings
   - Choose from multiple voice options
   - Enable debug logging for troubleshooting

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