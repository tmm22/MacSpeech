import SwiftUI

struct ContentView: View {
    @StateObject private var openAIService: OpenAIService
    @StateObject private var audioRecorder = AudioRecorder()
    @State private var showSettings = false
    @State private var apiKey: String = UserDefaults.standard.string(forKey: "OpenAIAPIKey") ?? ""
    @State private var showDebugLogs = false
    @State private var inputText: String = ""
    @State private var improvedText: String = ""
    @State private var isProcessing = false
    @State private var isTranscribing = false
    @State private var errorMessage: String?
    @State private var selectedVoice = "alloy"
    @State private var isSpeaking = false
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    private let availableVoices = ["alloy", "echo", "fable", "onyx", "nova", "shimmer"]
    
    init() {
        let savedAPIKey = UserDefaults.standard.string(forKey: "OpenAIAPIKey") ?? ""
        _openAIService = StateObject(wrappedValue: OpenAIService(apiKey: savedAPIKey))
    }
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Spacer()
                Button(action: { showSettings.toggle() }) {
                    Image(systemName: "gear")
                        .imageScale(.large)
                }
                .sheet(isPresented: $showSettings) {
                    VStack(spacing: 20) {
                        // Header
                        Text("Settings")
                            .font(.title)
                            .bold()
                        
                        // Content
                        VStack(spacing: 20) {
                            // API Settings
                            GroupBox {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("API Settings")
                                        .font(.headline)
                                    SecureField("OpenAI API Key", text: $apiKey)
                                        .textFieldStyle(.roundedBorder)
                                    Button("Save API Key") {
                                        openAIService.updateAPIKey(apiKey)
                                        UserDefaults.standard.set(apiKey, forKey: "OpenAIAPIKey")
                                    }
                                    .buttonStyle(.borderedProminent)
                                }
                                .padding(5)
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
                                        
                                        Text("GPT-4 models provide better results but cost more. GPT-3.5 models are faster and more cost-effective.")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                            .fixedSize(horizontal: false, vertical: true)
                                    }
                                }
                                .padding(5)
                            }
                            
                            // Appearance Settings
                            GroupBox {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("Appearance")
                                        .font(.headline)
                                    Toggle(isOn: $isDarkMode) {
                                        Label("Dark Mode", systemImage: isDarkMode ? "moon.fill" : "moon")
                                    }
                                }
                                .padding(5)
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
                                .padding(5)
                            }
                        }
                        .frame(width: 400)
                        
                        Spacer()
                        
                        Button("Close") {
                            showSettings = false
                        }
                        .keyboardShortcut(.escape)
                    }
                    .padding(20)
                    .frame(width: 440, height: 500)
                }
            }
            .padding(.horizontal)
            
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
                        improvedText = try await openAIService.improveText(inputText)
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
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .frame(width: 150)
                } else {
                    Text("Improve Text")
                        .frame(width: 150)
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(inputText.isEmpty || isProcessing)
            
            GroupBox(label: Text("Improved Text").bold()) {
                TextEditor(text: .constant(improvedText))
                    .frame(height: 100)
                    .padding(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
                    .background(Color(.textBackgroundColor))
                
                HStack {
                    Picker("Voice", selection: $selectedVoice) {
                        ForEach(availableVoices, id: \.self) { voice in
                            Text(voice.capitalized).tag(voice)
                        }
                    }
                    .frame(width: 120)
                    
                    Button(action: {
                        Task {
                            guard !improvedText.isEmpty else { return }
                            isSpeaking = true
                            do {
                                let audioData = try await openAIService.textToSpeech(
                                    text: improvedText,
                                    voice: selectedVoice
                                )
                                // Save audio data to temporary file
                                let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("speech.mp3")
                                try audioData.write(to: tempURL)
                                
                                // Play audio using afplay
                                let process = Process()
                                process.executableURL = URL(fileURLWithPath: "/usr/bin/afplay")
                                process.arguments = [tempURL.path]
                                try process.run()
                                process.waitUntilExit()
                                
                                // Clean up temp file
                                try? FileManager.default.removeItem(at: tempURL)
                            } catch {
                                errorMessage = error.localizedDescription
                            }
                            isSpeaking = false
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
    }
} 