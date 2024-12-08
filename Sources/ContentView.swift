import SwiftUI
import AppKit
import AVFoundation

// GitHub Release Response Model
private struct GitHubRelease: Codable {
    let tag_name: String
    let html_url: String
    let body: String
}

struct ExamplePromptButton: View {
    let title: String
    let prompt: String
    @Binding var customPromptText: String
    @ObservedObject var openAIService: OpenAIService
    
    var body: some View {
        Button(action: {
            customPromptText = prompt
            openAIService.updateCustomPrompt(prompt)
            UserDefaults.standard.set(prompt, forKey: "CustomPrompt")
        }) {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .buttonStyle(.bordered)
        .help("Use this example prompt")
    }
}

struct ContentView: View {
    @StateObject private var openAIService: OpenAIService
    @StateObject private var elevenLabsService: ElevenLabsService
    @StateObject private var audioRecorder = AudioRecorder()
    @State private var showSettings = false
    @State private var openAIApiKey: String = UserDefaults.standard.string(forKey: "OpenAIAPIKey") ?? ""
    @State private var elevenLabsApiKey: String = UserDefaults.standard.string(forKey: "ElevenLabsAPIKey") ?? ""
    @State private var showDebugLogs = false
    @State private var inputText: String = ""
    @State private var improvedText: String = ""
    @State private var isProcessing = false
    @State private var isTranscribing = false
    @State private var errorMessage: String?
    @State private var selectedVoice = "alloy"
    @State private var speechSpeed: Double = 1.0
    @State private var isSpeaking = false
    @State private var customPromptText: String = UserDefaults.standard.string(forKey: "CustomPrompt") ?? ""
    @State private var savedPrompts: [String] = UserDefaults.standard.stringArray(forKey: "SavedPrompts") ?? []
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("autoCopyImprovedText") private var autoCopyImprovedText = false
    @AppStorage("enableKeyboardShortcuts") private var enableKeyboardShortcuts = true
    @AppStorage("enableMiniMode") private var enableMiniMode = false
    @AppStorage("showProgressBar") private var showProgressBar = true
    @AppStorage("enableWordHighlighting") private var enableWordHighlighting = false
    @AppStorage("useElevenLabs") private var useElevenLabs = false
    @State private var currentWordIndex: Int = 0
    @State private var words: [String] = []
    @State private var highlightTimer: Timer?
    @State private var selectedPromptType: String = ""
    @State private var showingImporter = false
    @State private var showingExporter = false
    @State private var isCheckingForUpdates = false
    @State private var latestVersion: String?
    @State private var updateAvailable = false
    @State private var currentVersion: String = "1.1.48"
<<<<<<< HEAD
=======
    @State private var showPromptBuilder = false
>>>>>>> release/v1.1.49
    
    private let openAIVoices = ["alloy", "echo", "fable", "onyx", "nova", "shimmer"]
    
    private func loadVersion() {
        if let versionFileURL = Bundle.main.url(forResource: "version", withExtension: "txt"),
           let versionString = try? String(contentsOf: versionFileURL, encoding: .utf8) {
            currentVersion = versionString.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    
    private func exportPrompts() {
        let savePanel = NSSavePanel()
        savePanel.allowedContentTypes = [.json]
        savePanel.nameFieldStringValue = "custom_prompts.json"
        savePanel.title = "Export Custom Prompts"
        savePanel.message = "Choose where to save your custom prompts"
        
        savePanel.begin { response in
            if response == .OK {
                guard let url = savePanel.url else { return }
                
                do {
                    let jsonData = try JSONEncoder().encode(savedPrompts)
                    try jsonData.write(to: url)
                } catch {
                    print("Error exporting prompts: \(error)")
                }
            }
        }
    }
    
    private func importPrompts() {
        let openPanel = NSOpenPanel()
        openPanel.allowedContentTypes = [.json]
        openPanel.allowsMultipleSelection = false
        openPanel.title = "Import Custom Prompts"
        openPanel.message = "Select a custom prompts JSON file"
        
        openPanel.begin { response in
            if response == .OK {
                guard let url = openPanel.url else { return }
                
                do {
                    let jsonData = try Data(contentsOf: url)
                    let importedPrompts = try JSONDecoder().decode([String].self, from: jsonData)
                    
                    // Add new prompts while avoiding duplicates
                    for prompt in importedPrompts {
                        if !savedPrompts.contains(prompt) {
                            savedPrompts.append(prompt)
                        }
                    }
                    
                    // Save to UserDefaults
                    UserDefaults.standard.set(savedPrompts, forKey: "SavedPrompts")
                } catch {
                    print("Error importing prompts: \(error)")
                }
            }
        }
    }
    
    init() {
        let savedOpenAIKey = UserDefaults.standard.string(forKey: "OpenAIAPIKey") ?? ""
        let savedElevenLabsKey = UserDefaults.standard.string(forKey: "ElevenLabsAPIKey") ?? ""
        _openAIService = StateObject(wrappedValue: OpenAIService(apiKey: savedOpenAIKey))
        _elevenLabsService = StateObject(wrappedValue: ElevenLabsService(apiKey: savedElevenLabsKey))
    }
    
    private func startWordHighlighting() {
        words = improvedText.components(separatedBy: " ")
        currentWordIndex = 0
        
        // Calculate words per second based on text length and speed
        let wordsPerSecond = Double(words.count) / (Double(improvedText.count) * 0.06 / speechSpeed)
        let interval = 1.0 / wordsPerSecond
        
        highlightTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            if currentWordIndex < words.count {
                currentWordIndex += 1
            } else {
                highlightTimer?.invalidate()
                highlightTimer = nil
                currentWordIndex = 0
            }
        }
    }
    
    private func stopWordHighlighting() {
        highlightTimer?.invalidate()
        highlightTimer = nil
        currentWordIndex = 0
    }
    
    private func highlightedText() -> AttributedString {
        guard enableWordHighlighting && !words.isEmpty && currentWordIndex < words.count else {
            return AttributedString(improvedText)
        }
        
        var result = AttributedString()
        for (index, word) in words.enumerated() {
            if index > 0 {
                result += AttributedString(" ")
            }
            
            var wordAttr = AttributedString(word)
            if index == currentWordIndex {
                wordAttr.backgroundColor = .accentColor.opacity(0.3)
                wordAttr.foregroundColor = .primary
            }
            result += wordAttr
        }
        return result
    }
    
    private func speakText() async {
        guard !improvedText.isEmpty else { return }
        isSpeaking = true
        
        do {
            let audioData: Data
            if useElevenLabs {
                // Use ElevenLabs for TTS
                guard let selectedVoiceId = elevenLabsService.availableVoices.first(where: { $0.name == selectedVoice })?.voice_id else {
                    throw NSError(domain: "TTS", code: 0, userInfo: [NSLocalizedDescriptionKey: "No voice selected"])
                }
                audioData = try await elevenLabsService.textToSpeech(
                    text: improvedText,
                    voiceId: selectedVoiceId,
                    stability: 0.5,
                    similarityBoost: 0.75
                )
            } else {
                // Use OpenAI for TTS
                audioData = try await openAIService.textToSpeech(
                    text: improvedText,
                    voice: selectedVoice,
                    speed: Float(speechSpeed)
                )
            }
            
            if enableWordHighlighting {
                startWordHighlighting()
            }
            
            // Save audio data to temporary file
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("speech.mp3")
            try audioData.write(to: tempURL)
            
            // Play audio using AVAudioPlayer
            let player = try AVAudioPlayer(contentsOf: tempURL)
            player.play()
            while player.isPlaying {
                try await Task.sleep(nanoseconds: 100_000_000) // 0.1 second
            }
            
            // Clean up temp file
            try? FileManager.default.removeItem(at: tempURL)
            
            if enableWordHighlighting {
                stopWordHighlighting()
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isSpeaking = false
    }
    
    private func checkForUpdates() async {
        isCheckingForUpdates = true
        do {
            let url = URL(string: "https://api.github.com/repos/tmm22/MacSpeech/releases/latest")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let json = try JSONDecoder().decode(GitHubRelease.self, from: data)
            latestVersion = json.tag_name.replacingOccurrences(of: "v", with: "")
            
            if let latest = latestVersion {
                let latestComponents = latest.split(separator: ".").compactMap { Int($0) }
                let currentComponents = currentVersion.split(separator: ".").compactMap { Int($0) }
                
                if latestComponents.count == 3 && currentComponents.count == 3 {
                    // Break down the calculation for better type inference
                    let latestMajor = latestComponents[0] * 10000
                    let latestMinor = latestComponents[1] * 100
                    let latestPatch = latestComponents[2]
                    let latestNum = latestMajor + latestMinor + latestPatch
                    
                    let currentMajor = currentComponents[0] * 10000
                    let currentMinor = currentComponents[1] * 100
                    let currentPatch = currentComponents[2]
                    let currentNum = currentMajor + currentMinor + currentPatch
                    
                    updateAvailable = latestNum > currentNum
                }
            }
        } catch {
            errorMessage = "Failed to check for updates: \(error.localizedDescription)"
        }
        isCheckingForUpdates = false
    }
    
    private func openDownloadPage() {
        if let url = URL(string: "https://github.com/tmm22/MacSpeech/releases/latest") {
            NSWorkspace.shared.open(url)
        }
    }
    
    var settingsView: some View {
        VStack {
            Text("Settings")
                .font(.title)
                .bold()
                .padding(.top, 20)
            
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 20) {
                    // Updates Section
                    GroupBox {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Updates")
                                .font(.headline)
                            
                            HStack {
                                Text("Current Version: \(currentVersion)")
                                    .foregroundColor(.secondary)
                                Spacer()
                                if isCheckingForUpdates {
                                    ProgressView()
                                        .scaleEffect(0.7)
                                        .frame(width: 16, height: 16)
                                } else if let latest = latestVersion {
                                    if updateAvailable {
                                        Text("New version available: \(latest)")
                                            .foregroundColor(.green)
                                    } else {
                                        Text("Up to date")
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                            
                            HStack {
                                Button(action: {
                                    Task {
                                        await checkForUpdates()
                                    }
                                }) {
                                    Label("Check for Updates", systemImage: "arrow.clockwise")
                                }
                                .buttonStyle(.bordered)
                                .disabled(isCheckingForUpdates)
                                
                                if updateAvailable {
                                    Button(action: openDownloadPage) {
                                        Label("Download Update", systemImage: "arrow.down.circle")
                                    }
                                    .buttonStyle(.borderedProminent)
                                }
                            }
                        }
                        .padding(10)
                    }
                    
                    // API Settings
                    GroupBox {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("API Settings")
                                .font(.headline)
                            
                            // OpenAI API Key
                            Text("OpenAI API Key")
                                .font(.subheadline)
                            SecureField("OpenAI API Key", text: $openAIApiKey)
                                .textFieldStyle(.roundedBorder)
                            HStack {
                                Button("Save OpenAI API Key") {
                                    openAIService.updateAPIKey(openAIApiKey)
                                    UserDefaults.standard.set(openAIApiKey, forKey: "OpenAIAPIKey")
                                }
                                .buttonStyle(.borderedProminent)
                                
                                Button("Test OpenAI") {
                                    Task {
                                        do {
                                            let result = try await openAIService.testConnection()
                                            errorMessage = nil
                                            showAlert = true
                                            alertTitle = "OpenAI Test"
                                            alertMessage = result
                                        } catch {
                                            errorMessage = error.localizedDescription
                                        }
                                    }
                                }
                                .buttonStyle(.bordered)
                            }
                            
                            Divider()
                            
                            // ElevenLabs API Key
                            Text("ElevenLabs API Key (Optional)")
                                .font(.subheadline)
                            SecureField("ElevenLabs API Key", text: $elevenLabsApiKey)
                                .textFieldStyle(.roundedBorder)
                            HStack {
                                Button("Save ElevenLabs API Key") {
                                    elevenLabsService.updateAPIKey(elevenLabsApiKey)
                                    UserDefaults.standard.set(elevenLabsApiKey, forKey: "ElevenLabsAPIKey")
                                }
                                .buttonStyle(.borderedProminent)
                                
                                Button("Test ElevenLabs") {
                                    Task {
                                        do {
                                            let result = try await elevenLabsService.testConnection()
                                            errorMessage = nil
                                            showAlert = true
                                            alertTitle = "ElevenLabs Test"
                                            alertMessage = result
                                        } catch {
                                            errorMessage = error.localizedDescription
                                        }
                                    }
                                }
                                .buttonStyle(.bordered)
                                .disabled(elevenLabsApiKey.isEmpty)
                            }
                            
                            Toggle("Use ElevenLabs for Text-to-Speech", isOn: $useElevenLabs)
                                .help("Enable to use ElevenLabs instead of OpenAI for text-to-speech")
                                .disabled(elevenLabsApiKey.isEmpty)
                        }
                        .padding(10)
                    }
                    
                    // Model Selection
                    GroupBox {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Model Selection")
                                .font(.headline)
                            if openAIService.availableModels.isEmpty {
                                Text("No models available. Please check your API key.")
                                    .foregroundColor(.secondary)
                            } else {
                                Picker("Model", selection: $openAIService.selectedModel) {
                                    ForEach(openAIService.availableModels, id: \.self) { model in
                                        Text(model)
                                            .tag(model)
                                    }
                                }
                                .pickerStyle(.menu)
                            }
                        }
                        .padding(10)
                    }
                    
                    // Voice Selection
                    GroupBox {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Voice Selection")
                                .font(.headline)
                            
                            if useElevenLabs {
                                if elevenLabsService.availableVoices.isEmpty {
                                    Text("No ElevenLabs voices available. Please check your API key.")
                                        .foregroundColor(.secondary)
                                } else {
                                    Picker("Voice", selection: $selectedVoice) {
                                        ForEach(elevenLabsService.availableVoices) { voice in
                                            Text(voice.name)
                                                .tag(voice.name)
                                        }
                                    }
                                    .pickerStyle(.menu)
                                }
                            } else {
                                Picker("Voice", selection: $selectedVoice) {
                                    ForEach(openAIVoices, id: \.self) { voice in
                                        Text(voice)
                                            .tag(voice)
                                    }
                                }
                                .pickerStyle(.menu)
                                
                                Slider(value: $speechSpeed, in: 0.5...4.0, step: 0.1) {
                                    Text("Speed: \(speechSpeed, specifier: "%.1f")x")
                                }
                            }
                        }
                        .padding(10)
                    }
                    
                    // Custom Prompts Management
                    GroupBox {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Custom Prompts Management")
                                .font(.headline)
                            
                            Toggle(isOn: $openAIService.useCustomPrompt) {
                                Label("Use Custom Prompt", systemImage: "text.quote")
                            }
                            .help("Enable to use a custom improvement prompt")
                            
                            Divider()
                            
                            Text("Example Prompts & Templates")
                                .font(.headline)
                                .padding(.top, 5)
                            
                            Text("Click any example below to use it as your custom prompt:")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            ScrollView {
                                VStack(alignment: .leading, spacing: 10) {
                                    Group {
                                        ExamplePromptButton(
                                            title: "Professional Writing",
                                            prompt: """
                                            You are a professional writing assistant. Your task is to:
                                            1. Improve grammar and clarity
                                            2. Use professional language and tone
                                            3. Ensure proper formatting
                                            4. Maintain conciseness
                                            5. Keep the message clear and effective
                                            """,
                                            customPromptText: $customPromptText,
                                            openAIService: openAIService
                                        )
                                        
                                        ExamplePromptButton(
                                            title: "Technical Documentation",
                                            prompt: """
                                            You are a technical documentation specialist. Your task is to:
                                            1. Use precise technical language
                                            2. Maintain clarity and accuracy
                                            3. Follow technical writing standards
                                            4. Add proper structure
                                            5. Ensure consistency in terminology
                                            """,
                                            customPromptText: $customPromptText,
                                            openAIService: openAIService
                                        )
                                        
                                        ExamplePromptButton(
                                            title: "Creative Writing",
                                            prompt: """
                                            You are a creative writing enhancer. Your task is to:
                                            1. Maintain creative elements
                                            2. Enhance descriptive language
                                            3. Improve flow and rhythm
                                            4. Keep the original style
                                            5. Add engaging elements while preserving meaning
                                            """,
                                            customPromptText: $customPromptText,
                                            openAIService: openAIService
                                        )
                                    }
                                }
                            }
                            .frame(height: 200)
                            
                            if openAIService.useCustomPrompt {
                                Divider()
                                
                                Text("Current Custom Prompt:")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                TextEditor(text: $customPromptText)
                                    .font(.system(.body, design: .monospaced))
                                    .frame(height: 150)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 4)
                                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                    )
                                
                                HStack {
                                    Button("Save as Preset") {
                                        if !customPromptText.isEmpty && !savedPrompts.contains(customPromptText) {
                                            savedPrompts.append(customPromptText)
                                            UserDefaults.standard.set(savedPrompts, forKey: "SavedPrompts")
                                            UserDefaults.standard.set(customPromptText, forKey: "CustomPrompt")
                                            openAIService.updateCustomPrompt(customPromptText)
                                        }
                                    }
                                    .buttonStyle(.bordered)
                                    
                                    Button("Update Current") {
                                        openAIService.updateCustomPrompt(customPromptText)
                                        UserDefaults.standard.set(customPromptText, forKey: "CustomPrompt")
                                    }
                                    .buttonStyle(.borderedProminent)
                                }
                                
                                HStack {
                                    Button(action: exportPrompts) {
                                        Label("Export All Prompts", systemImage: "square.and.arrow.up")
                                    }
                                    .buttonStyle(.bordered)
                                    .help("Export all your custom prompts to a file")
                                    
                                    Button(action: importPrompts) {
                                        Label("Import Prompts", systemImage: "square.and.arrow.down")
                                    }
                                    .buttonStyle(.bordered)
                                    .help("Import custom prompts from a file")
                                }
                                
                                Divider()
                                
                                Button(action: { showPromptBuilder.toggle() }) {
                                    Label("Smart Prompt Builder", systemImage: "wand.and.stars")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(.bordered)
                                .help("Open the Smart Prompt Builder to create custom prompts")
                                .sheet(isPresented: $showPromptBuilder) {
                                    PromptBuilder(generatedPrompt: $customPromptText)
                                        .frame(width: 300)
                                }
                            }
                        }
                        .padding(10)
                    }
                    
                    // Appearance Settings
                    GroupBox {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Appearance")
                                .font(.headline)
                            Toggle(isOn: $isDarkMode) {
                                Label("Dark Mode", systemImage: isDarkMode ? "moon.fill" : "moon")
                            }
                            Toggle(isOn: $autoCopyImprovedText) {
                                Label("Auto-copy improved text", systemImage: "doc.on.doc")
                            }
                        }
                        .padding(10)
                    }
                    
                    // UI Customization
                    GroupBox {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("UI Customization")
                                .font(.headline)
                            Toggle(isOn: $enableKeyboardShortcuts) {
                                Label("Enable Keyboard Shortcuts", systemImage: "keyboard")
                            }
                            .help("Use keyboard shortcuts for common actions")
                            
                            Toggle(isOn: $enableMiniMode) {
                                Label("Enable Mini Mode", systemImage: "rectangle.compress.vertical")
                            }
                            .help("Compact window with essential controls")
                            
                            Toggle(isOn: $showProgressBar) {
                                Label("Show Progress Bar", systemImage: "chart.bar.fill")
                            }
                            .help("Display progress during text processing")
                            
                            Toggle(isOn: $enableWordHighlighting) {
                                Label("Enable Word Highlighting", systemImage: "text.highlight")
                            }
                            .help("Highlight words during speech playback")
                        }
                        .padding(10)
                    }
                    
                    // Debug Settings
                    GroupBox {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Debug")
                                .font(.headline)
                            Toggle("Show Debug Logs", isOn: $showDebugLogs)
                            if showDebugLogs {
                                ScrollView {
                                    Text(openAIService.debugLog)
                                        .font(.system(.caption, design: .monospaced))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .frame(height: 100)
                                .background(Color(.textBackgroundColor))
                                .cornerRadius(4)
                            }
                        }
                        .padding(10)
                    }
                }
                .padding()
            }
            
            Button("Close") {
                showSettings = false
            }
            .keyboardShortcut(.escape)
            .padding(.bottom, 20)
        }
        .frame(width: 440)
        .background(Color(.windowBackgroundColor))
    }
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                if !enableMiniMode {
                    Text("MacSpeechApp")
                        .font(.headline)
                }
                Spacer()
                Button(action: { showSettings.toggle() }) {
                    Image(systemName: "gear")
                        .imageScale(.large)
                }
            }
            .padding(.horizontal)
            .sheet(isPresented: $showSettings) {
                settingsView
            }
            .onAppear {
                loadVersion()
                Task {
                    await checkForUpdates()
                }
            }
            
            GroupBox(label: Text("Input Text").bold()) {
                TextEditor(text: $inputText)
                    .frame(height: 100)
                    .padding(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
                    .background(Color(.textBackgroundColor))
            }
            
            Button(action: {
                Task {
                    isProcessing = true
                    errorMessage = nil
                    do {
                        if showProgressBar {
                            withAnimation {
                                improvedText = "Processing..."
                            }
                        }
                        improvedText = try await openAIService.improveText(inputText)
                        if autoCopyImprovedText {
                            NSPasteboard.general.clearContents()
                            NSPasteboard.general.setString(improvedText, forType: .string)
                        }
                    } catch let error as OpenAIError {
                        errorMessage = error.error.message
                        improvedText = "Error: \(error.error.message)"
                    } catch {
                        errorMessage = error.localizedDescription
                        improvedText = "Error: \(error.localizedDescription)"
                    }
                    isProcessing = false
                }
            }) {
                if isProcessing {
                    VStack {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                        if showProgressBar {
                            ProgressView(value: 0.5)
                                .progressViewStyle(.linear)
                                .frame(width: 100)
                        }
                    }
                    .frame(width: 150)
                } else {
                    Text("Improve Text")
                        .frame(width: 150)
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(inputText.isEmpty || isProcessing)
            .keyboardShortcut("i", modifiers: enableKeyboardShortcuts ? [.command] : [])
            
            GroupBox(label: Text("Improved Text").bold()) {
                if enableWordHighlighting && isSpeaking {
                    Text(highlightedText())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 100)
                        .padding(5)
                        .background(Color(.textBackgroundColor))
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                } else {
                    TextEditor(text: .constant(improvedText))
                        .frame(height: 100)
                        .padding(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                        .background(Color(.textBackgroundColor))
                }
                
                HStack {
                    Button(action: {
                        Task {
                            await speakText()
                        }
                    }) {
                        if isSpeaking {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .frame(width: 100)
                        } else {
                            Label("Speak", systemImage: "speaker.wave.2.fill")
                                .frame(width: 100)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(improvedText.isEmpty || isSpeaking)
                    .keyboardShortcut("p", modifiers: enableKeyboardShortcuts ? [.command] : [])
                    
                    Button(action: {
                        NSPasteboard.general.clearContents()
                        NSPasteboard.general.setString(improvedText, forType: .string)
                    }) {
                        Label("Copy", systemImage: "doc.on.doc")
                            .frame(width: 100)
                    }
                    .buttonStyle(.bordered)
                    .disabled(improvedText.isEmpty)
                    .keyboardShortcut("c", modifiers: enableKeyboardShortcuts ? [.command, .shift] : [])
                }
                .padding(.top, 8)
            }
            
            // Speech to Text Section
            GroupBox(label: Text("Speech to Text").bold()) {
                VStack(spacing: 10) {
                    if !audioRecorder.permissionGranted {
                        VStack(spacing: 10) {
                            if let error = audioRecorder.permissionError {
                                Text(error)
                                    .foregroundColor(.red)
                                    .multilineTextAlignment(.center)
                            } else {
                                Text("Microphone access is required for speech-to-text.")
                                    .foregroundColor(.secondary)
                            }
                            Button("Request Permissions") {
                                audioRecorder.requestPermissions()
                            }
                            .buttonStyle(.borderedProminent)
                            Button("Open System Settings") {
                                if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Microphone") {
                                    NSWorkspace.shared.open(url)
                                }
                            }
                            .buttonStyle(.bordered)
                        }
                        .padding()
                    } else {
                        HStack {
                            Button(action: {
                                if audioRecorder.isRecording {
                                    audioRecorder.stopRecording()
                                    Task {
                                        isTranscribing = true
                                        if let audioData = audioRecorder.getAudioData() {
                                            do {
                                                inputText = try await openAIService.transcribeAudio(audioData)
                                            } catch {
                                                errorMessage = error.localizedDescription
                                            }
                                        }
                                        isTranscribing = false
                                        audioRecorder.cleanup()
                                    }
                                } else {
                                    audioRecorder.startRecording()
                                }
                            }) {
                                if isTranscribing {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle())
                                        .frame(width: 150)
                                } else {
                                    Label(
                                        audioRecorder.isRecording ? "Stop Recording" : "Start Recording",
                                        systemImage: audioRecorder.isRecording ? "stop.circle.fill" : "mic.circle.fill"
                                    )
                                    .frame(width: 150)
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            .disabled(isTranscribing)
                        }
                    }
                }
            }
            
            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            
            if showDebugLogs {
                GroupBox(label: Text("Debug Logs").bold()) {
                    ScrollView {
                        Text(openAIService.debugLog)
                            .font(.system(.caption, design: .monospaced))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(height: 100)
                }
            }
            
            Spacer()
            
            Button(action: {
                if let url = URL(string: "https://github.com/tmm22/MacSpeech") {
                    NSWorkspace.shared.open(url)
                }
            }) {
                HStack {
                    Image(systemName: "github")
                    Text("Contribute on GitHub")
                }
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
            }
            .buttonStyle(.link)
            .font(.caption)
            
            HStack(spacing: 20) {
                Button(action: {
                    Task {
                        do {
                            _ = try await openAIService.testConnection()
                        } catch {
                            print("Test failed: \(error.localizedDescription)")
                        }
                    }
                }) {
                    Label("Test API", systemImage: "network")
                }
                .buttonStyle(.bordered)
                
                Button(action: {
                    showDebugLogs.toggle()
                }) {
                    Label(showDebugLogs ? "Hide Logs" : "Show Logs", 
                          systemImage: showDebugLogs ? "eye.slash" : "eye")
                }
                .buttonStyle(.bordered)
                
                Button(action: {
                    Task { @MainActor in
                        openAIService.clearLogs()
                    }
                }) {
                    Label("Clear Logs", systemImage: "trash")
                }
                .buttonStyle(.bordered)
                
                Button(action: { showSettings.toggle() }) {
                    Label("Settings", systemImage: "gear")
                }
                .buttonStyle(.bordered)
            }
            
            Spacer()
        }
        .padding()
        .frame(minWidth: 500, minHeight: 600)
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .alert(alertTitle, isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
} 