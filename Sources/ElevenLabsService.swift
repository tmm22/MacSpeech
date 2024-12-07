import Foundation

@MainActor
class ElevenLabsService: ObservableObject {
    @Published private(set) var apiKey: String
    @Published var debugLog: String = ""
    @Published var availableVoices: [Voice] = []
    
    private let baseURL = "https://api.elevenlabs.io/v1"
    private var urlSession: URLSession
    
    struct Voice: Codable, Identifiable {
        let voice_id: String
        let name: String
        let preview_url: String?
        let category: String?
        
        var id: String { voice_id }
    }
    
    init(apiKey: String) {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 300
        self.urlSession = URLSession(configuration: config)
        self.apiKey = apiKey
        
        log("ElevenLabsService initialized")
        Task {
            await fetchAvailableVoices()
        }
    }
    
    private func log(_ message: String) {
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
        debugLog = "[\(timestamp)] \(message)\n" + debugLog
    }
    
    private func verifyAPIKey() -> Bool {
        guard !apiKey.isEmpty else {
            log("❌ API key is empty")
            return false
        }
        log("✅ API key format is valid")
        return true
    }
    
    private func createRequest(path: String, method: String = "GET", body: Data? = nil) -> URLRequest {
        var request = URLRequest(url: URL(string: "\(baseURL)/\(path)")!)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "xi-api-key")
        request.httpBody = body
        return request
    }
    
    func updateAPIKey(_ newKey: String) {
        apiKey = newKey
        UserDefaults.standard.set(apiKey, forKey: "ElevenLabsAPIKey")
        Task {
            await fetchAvailableVoices()
        }
    }
    
    func fetchAvailableVoices() async {
        guard verifyAPIKey() else {
            availableVoices = []
            return
        }
        
        do {
            let request = createRequest(path: "voices")
            let (data, response) = try await urlSession.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                log("❌ Invalid response type")
                return
            }
            
            log("📥 Voices response status code: \(httpResponse.statusCode)")
            
            if httpResponse.statusCode == 200 {
                struct VoicesResponse: Codable {
                    let voices: [Voice]
                }
                
                let result = try JSONDecoder().decode(VoicesResponse.self, from: data)
                self.availableVoices = result.voices
                log("✅ Fetched \(result.voices.count) available voices")
                result.voices.forEach { voice in
                    log("  • \(voice.name) (\(voice.voice_id))")
                }
            } else {
                log("❌ Failed to fetch voices: HTTP \(httpResponse.statusCode)")
            }
        } catch {
            log("❌ Error fetching voices: \(error.localizedDescription)")
        }
    }
    
    func textToSpeech(
        text: String,
        voiceId: String,
        stability: Float = 0.5,
        similarityBoost: Float = 0.75,
        style: Float = 0.0,
        speakerBoost: Bool = true
    ) async throws -> Data {
        guard verifyAPIKey() else {
            throw NSError(domain: "ElevenLabs", code: 401, userInfo: [NSLocalizedDescriptionKey: "Invalid API key"])
        }
        
        log("🎤 Converting text to speech using voice ID: \(voiceId)")
        
        let payload: [String: Any] = [
            "text": text,
            "model_id": "eleven_multilingual_v2",
            "voice_settings": [
                "stability": stability,
                "similarity_boost": similarityBoost,
                "style": style,
                "speaker_boost": speakerBoost
            ]
        ]
        
        let jsonData = try JSONSerialization.data(withJSONObject: payload)
        let request = createRequest(path: "text-to-speech/\(voiceId)", method: "POST", body: jsonData)
        
        do {
            let (audioData, response) = try await urlSession.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NSError(domain: "ElevenLabs", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response type"])
            }
            
            if httpResponse.statusCode != 200 {
                throw NSError(domain: "ElevenLabs", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Speech generation failed"])
            }
            
            log("✅ Successfully generated speech audio")
            return audioData
        } catch {
            log("❌ Error generating speech: \(error.localizedDescription)")
            throw error
        }
    }
    
    func clearLogs() {
        debugLog = ""
        log("🧹 Logs cleared")
    }
    
    func testConnection() async throws -> String {
        guard verifyAPIKey() else {
            throw NSError(domain: "ElevenLabs", code: 401, userInfo: [NSLocalizedDescriptionKey: "Invalid API key"])
        }
        
        log("🧪 Starting ElevenLabs API connection test")
        
        do {
            // First test: Fetch voices
            let request = createRequest(path: "voices")
            let (data, response) = try await urlSession.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NSError(domain: "ElevenLabs", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response type"])
            }
            
            if httpResponse.statusCode != 200 {
                throw NSError(domain: "ElevenLabs", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch voices"])
            }
            
            struct VoicesResponse: Codable {
                let voices: [Voice]
            }
            
            let result = try JSONDecoder().decode(VoicesResponse.self, from: data)
            
            // Second test: Generate a short sample
            if let firstVoice = result.voices.first {
                let testText = "This is a test of the ElevenLabs text-to-speech system."
                log("📝 Test text: '\(testText)'")
                
                let audioData = try await textToSpeech(
                    text: testText,
                    voiceId: firstVoice.voice_id
                )
                
                let resultMessage = """
                    Test successful!
                    
                    Available Voices: \(result.voices.count)
                    First Voice: \(firstVoice.name)
                    Generated Audio Size: \(audioData.count) bytes
                    
                    API connection is working correctly.
                    """
                log("✅ Test completed successfully")
                return resultMessage
            } else {
                throw NSError(domain: "ElevenLabs", code: 0, userInfo: [NSLocalizedDescriptionKey: "No voices available"])
            }
        } catch {
            log("❌ Test failed: \(error.localizedDescription)")
            throw error
        }
    }
} 