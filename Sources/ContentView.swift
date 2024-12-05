import SwiftUI

struct ContentView: View {
    @StateObject private var openAIService: OpenAIService
    @State private var showSettings = false
    @State private var apiKey: String = UserDefaults.standard.string(forKey: "OpenAIAPIKey") ?? ""
    @State private var showDebugLogs = false
    @State private var inputText: String = ""
    @State private var improvedText: String = ""
    @State private var isProcessing = false
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
                    NavigationView {
                        Form {
                            Section(header: Text("API Settings")) {
                                SecureField("OpenAI API Key", text: $apiKey)
                                Button("Save API Key") {
                                    openAIService.updateAPIKey(apiKey)
                                    UserDefaults.standard.set(apiKey, forKey: "OpenAIAPIKey")
                                }
                            }
                            
                            Section(header: Text("Appearance")) {
                                Toggle(isOn: $isDarkMode) {
                                    Label("Dark Mode", systemImage: isDarkMode ? "moon.fill" : "moon")
                                }
                            }
                            
                            Section(header: Text("Debug")) {
                                Toggle("Show Debug Logs", isOn: $showDebugLogs)
                                if showDebugLogs {
                                    Text(openAIService.debugLog)
                                        .font(.system(.caption, design: .monospaced))
                                }
                            }
                        }
                        .navigationTitle("Settings")
                    }
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
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
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
        .frame(minWidth: 600, minHeight: 700)
        .sheet(isPresented: $showSettings) {
            SettingsView(apiKey: $apiKey, openAIService: openAIService)
        }
    }
}

struct SettingsView: View {
    @Binding var apiKey: String
    @ObservedObject var openAIService: OpenAIService
    @Environment(\.dismiss) var dismiss
    @State private var showAPIKey = false
    @State private var selectedModelId: String
    
    init(apiKey: Binding<String>, openAIService: OpenAIService) {
        self._apiKey = apiKey
        self.openAIService = openAIService
        self._selectedModelId = State(initialValue: openAIService.selectedModel)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Settings")
                    .font(.system(size: 32, weight: .bold))
                Spacer()
                Button("Done") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal, 40)
            .padding(.vertical, 20)
            .background(Color(.windowBackgroundColor))
            
            // Main Content in ScrollView
            ScrollView {
                VStack(spacing: 40) {
                    // API Key Section
                    VStack(alignment: .leading, spacing: 20) {
                        Text("1. Enter Your OpenAI API Key")
                            .font(.system(size: 24, weight: .semibold))
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                if showAPIKey {
                                    TextField("Paste your API key here", text: $apiKey)
                                        .textFieldStyle(.roundedBorder)
                                        .font(.system(size: 18))
                                        .frame(height: 44)
                                } else {
                                    SecureField("Paste your API key here", text: $apiKey)
                                        .textFieldStyle(.roundedBorder)
                                        .font(.system(size: 18))
                                        .frame(height: 44)
                                }
                                
                                Button(action: { showAPIKey.toggle() }) {
                                    Image(systemName: showAPIKey ? "eye.slash.fill" : "eye.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(.secondary)
                                }
                                .buttonStyle(.plain)
                                .frame(width: 44, height: 44)
                            }
                        }
                        .onChange(of: apiKey) { newValue in
                            Task { @MainActor in
                                openAIService.updateAPIKey(newValue)
                            }
                        }
                    }
                    
                    // Model Selection Section
                    VStack(alignment: .leading, spacing: 20) {
                        Text("2. Choose Your Model")
                            .font(.system(size: 24, weight: .semibold))
                        
                        if !openAIService.availableModels.isEmpty {
                            VStack(spacing: 16) {
                                ForEach(openAIService.availableModels, id: \.self) { model in
                                    Button(action: {
                                        withAnimation {
                                            selectedModelId = model
                                            openAIService.updateSelectedModel(model)
                                        }
                                    }) {
                                        HStack(spacing: 16) {
                                            Image(systemName: selectedModelId == model ? "checkmark.circle.fill" : "circle")
                                                .font(.system(size: 24))
                                                .foregroundColor(selectedModelId == model ? .accentColor : .secondary)
                                            
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(model)
                                                    .font(.system(size: 18, design: .monospaced))
                                                Text(modelDescription(for: model))
                                                    .font(.system(size: 14))
                                                    .foregroundColor(.secondary)
                                            }
                                            Spacer()
                                        }
                                        .padding(16)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color(.windowBackgroundColor))
                                                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                                        )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            
                            Text("Note: GPT-4 models provide higher quality results but may be slower and more expensive.")
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                                .padding(.top, 8)
                        } else {
                            HStack {
                                Image(systemName: "key.fill")
                                    .font(.system(size: 24))
                                Text("Enter your API key to see available models")
                                    .font(.system(size: 18))
                            }
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity)
                            .padding(24)
                            .background(Color(.windowBackgroundColor))
                            .cornerRadius(12)
                        }
                    }
                }
                .padding(40)
            }
        }
        .frame(width: 700, height: 600)
        .background(Color(.textBackgroundColor))
    }
    
    private func modelDescription(for model: String) -> String {
        let model = model.lowercased()
        if model.contains("gpt-4") {
            if model.contains("turbo") {
                return "Latest GPT-4 model with improved performance"
            } else {
                return "Most capable GPT-4 model for complex tasks"
            }
        } else if model.contains("gpt-3.5") {
            if model.contains("turbo") {
                return "Fast and cost-effective for most tasks"
            } else {
                return "Standard GPT-3.5 model for general use"
            }
        }
        return "OpenAI language model"
    }
} 