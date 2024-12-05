import Foundation

@MainActor
class OpenAIService: ObservableObject {
    @Published private(set) var apiKey: String
    @Published var debugLog: String = ""
    @Published var availableModels: [String] = []
    @Published var selectedModel: String {
        didSet {
            UserDefaults.standard.set(selectedModel, forKey: "SelectedModel")
            log("Selected model changed to: \(selectedModel)")
        }
    }
    
    private let baseURL = "https://api.openai.com/v1"
    private var urlSession: URLSession
    
    init(apiKey: String) {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 300
        self.urlSession = URLSession(configuration: config)
        self.apiKey = apiKey
        self.selectedModel = UserDefaults.standard.string(forKey: "SelectedModel") ?? "gpt-3.5-turbo"
        
        log("OpenAIService initialized")
        Task {
            await fetchAvailableModels()
        }
    }
    
    func updateAPIKey(_ newKey: String) {
        apiKey = newKey
        UserDefaults.standard.set(apiKey, forKey: "OpenAIAPIKey")
        Task {
            await fetchAvailableModels()
        }
    }
    
    func updateSelectedModel(_ model: String) {
        if availableModels.contains(model) {
            selectedModel = model
            log("Model updated to: \(model)")
        } else {
            log("⚠️ Attempted to select unavailable model: \(model)")
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
        
        guard apiKey.starts(with: "sk-") else {
            log("❌ API key doesn't start with 'sk-'")
            return false
        }
        
        log("✅ API key format is valid")
        return true
    }
    
    private func createRequest(path: String, method: String = "GET", body: Data? = nil) -> URLRequest {
        var request = URLRequest(url: URL(string: "\(baseURL)/\(path)")!)
        request.httpMethod = method
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        return request
    }
    
    func fetchAvailableModels() async {
        guard verifyAPIKey() else {
            availableModels = []
            return
        }
        
        do {
            let request = createRequest(path: "models")
            let (data, response) = try await urlSession.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                log("❌ Invalid response type")
                return
            }
            
            log("📥 Models response status code: \(httpResponse.statusCode)")
            
            if httpResponse.statusCode == 200 {
                let result = try JSONDecoder().decode(ModelsResponse.self, from: data)
                let supportedModels = result.data
                    .map { $0.id }
                    .filter { model in
                        // Only include GPT models
                        model.contains("gpt-") &&
                        // Exclude instruct models and other variants
                        !model.contains("instruct") &&
                        !model.contains("vision") &&
                        !model.contains("0301") &&  // Older versions
                        !model.contains("0314")     // Older versions
                    }
                    .sorted { model1, model2 in
                        // Sort by model family
                        let families = ["gpt-4", "gpt-3.5"]
                        let getModelPriority = { (model: String) -> Int in
                            if let index = families.firstIndex(where: { model.contains($0) }) {
                                return index
                            }
                            return families.count
                        }
                        
                        let priority1 = getModelPriority(model1)
                        let priority2 = getModelPriority(model2)
                        
                        if priority1 != priority2 {
                            return priority1 < priority2
                        }
                        
                        // Within same family, sort newest first
                        let getDate = { (model: String) -> String in
                            if let range = model.range(of: #"\d{4}"#, options: .regularExpression) {
                                return String(model[range])
                            }
                            return "0000"
                        }
                        
                        let date1 = getDate(model1)
                        let date2 = getDate(model2)
                        if date1 != date2 {
                            return date1 > date2
                        }
                        
                        // If no date, sort by name
                        return model1 < model2
                    }
                
                self.availableModels = supportedModels
                log("✅ Fetched \(supportedModels.count) available models:")
                supportedModels.forEach { model in
                    log("  • \(model)")
                }
                
                // If current selected model is not in available models, select the first one
                if !supportedModels.contains(selectedModel), let firstModel = supportedModels.first {
                    selectedModel = firstModel
                    log("Selected default model: \(firstModel)")
                }
            } else {
                let errorData = try? JSONDecoder().decode(OpenAIError.self, from: data)
                log("❌ Failed to fetch models: HTTP \(httpResponse.statusCode)")
                if let error = errorData {
                    log("Error: \(error.error.message)")
                }
            }
        } catch {
            log("❌ Error fetching models: \(error.localizedDescription)")
        }
    }
    
    func improveText(_ text: String) async throws -> String {
        log("🔄 Starting text improvement process")
        log("📝 Input text: '\(text)'")
        log("🤖 Using model: \(selectedModel)")
        
        guard verifyAPIKey() else {
            throw OpenAIError(error: .init(message: "Invalid API key format", type: "invalid_api_key", param: nil, code: nil))
        }
        
        // Adjust payload based on model type
        let payload: [String: Any]
        
        if selectedModel.contains("gpt") {
            // GPT models use chat completions
            payload = [
                "model": selectedModel,
                "messages": [
                    ["role": "system", "content": """
                    You are a text improvement assistant. Your task is to:
                    1. Fix grammar and spelling
                    2. Improve punctuation and formatting
                    3. Enhance clarity while maintaining the original meaning and tone
                    4. Return only the corrected text without explanations
                    """],
                    ["role": "user", "content": text]
                ],
                "temperature": 0.3,
                "max_tokens": 4096,
                "top_p": 1,
                "frequency_penalty": 0,
                "presence_penalty": 0,
                "response_format": ["type": "text"]
            ]
        } else if selectedModel.contains("text-embedding") {
            throw OpenAIError(error: .init(message: "Embedding models cannot be used for text improvement", type: "invalid_model", param: nil, code: nil))
        } else if selectedModel.contains("dall-e") {
            throw OpenAIError(error: .init(message: "Image models cannot be used for text improvement", type: "invalid_model", param: nil, code: nil))
        } else {
            throw OpenAIError(error: .init(message: "Unsupported model type", type: "invalid_model", param: nil, code: nil))
        }
        
        let jsonData = try JSONSerialization.data(withJSONObject: payload)
        let request = createRequest(path: "chat/completions", method: "POST", body: jsonData)
        
        do {
            log("📤 Sending request to OpenAI")
            
            let (data, response) = try await urlSession.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw OpenAIError(error: .init(message: "Invalid response type", type: "invalid_response", param: nil, code: nil))
            }
            
            log("📥 Response status code: \(httpResponse.statusCode)")
            
            if httpResponse.statusCode != 200 {
                let errorData = try? JSONDecoder().decode(OpenAIError.self, from: data)
                let errorMessage = errorData?.error.message ?? "Request failed with status \(httpResponse.statusCode)"
                let errorType = errorData?.error.type ?? "api_error"
                
                switch httpResponse.statusCode {
                case 401:
                    throw OpenAIError(error: .init(message: "Invalid API key", type: "invalid_api_key", param: nil, code: nil))
                case 429:
                    throw OpenAIError(error: .init(message: "Rate limit exceeded. Please wait a moment and try again.", type: "rate_limit_exceeded", param: nil, code: nil))
                case 400:
                    throw OpenAIError(error: .init(message: errorMessage, type: "invalid_request", param: nil, code: nil))
                case 500, 502, 503, 504:
                    throw OpenAIError(error: .init(message: "OpenAI service is currently unavailable. Please try again later.", type: "service_unavailable", param: nil, code: nil))
                default:
                    throw OpenAIError(error: .init(message: errorMessage, type: errorType, param: nil, code: nil))
                }
            }
            
            let result = try JSONDecoder().decode(OpenAIResponse.self, from: data)
            if let improvedText = result.choices.first?.message.content.trimmingCharacters(in: .whitespacesAndNewlines) {
                log("✅ Successfully improved text")
                log("✨ Improved: '\(improvedText)'")
                return improvedText
            } else {
                log("⚠️ No improved text in response")
                return text
            }
        } catch let error as OpenAIError {
            log("❌ Error: \(error.error.message)")
            throw error
        } catch {
            log("❌ Error: \(error.localizedDescription)")
            throw OpenAIError(error: .init(message: error.localizedDescription, type: "unknown_error", param: nil, code: nil))
        }
    }
    
    func testConnection() async throws -> String {
        log("🧪 Starting API connection test")
        
        let testText = "this is a test message with bad grammar and no punctuation lets see if it works"
        log("📝 Test text: '\(testText)'")
        
        do {
            let improvedText = try await improveText(testText)
            let resultMessage = """
                Test successful!
                
                Original: "\(testText)"
                Improved: "\(improvedText)"
                
                Using model: \(selectedModel)
                API connection is working correctly.
                """
            log("✅ Test completed successfully")
            return resultMessage
        } catch let error as OpenAIError {
            log("❌ Test failed: \(error.error.message)")
            throw error
        } catch {
            log("❌ Test failed: \(error.localizedDescription)")
            throw OpenAIError(error: .init(message: error.localizedDescription, type: "unknown_error", param: nil, code: nil))
        }
    }
    
    func clearLogs() {
        debugLog = ""
        log("🧹 Logs cleared")
    }
    
    func generateImage(_ prompt: String, size: String = "1024x1024", quality: String = "standard", style: String = "natural") async throws -> Data {
        guard selectedModel.contains("dall-e") else {
            throw OpenAIError(error: .init(message: "Selected model is not an image generation model", type: "invalid_model", param: nil, code: nil))
        }
        
        log("🎨 Generating image with DALL-E")
        log("📝 Prompt: '\(prompt)'")
        
        let payload: [String: Any] = [
            "model": selectedModel,
            "prompt": prompt,
            "size": size,
            "quality": quality,
            "style": style,
            "n": 1
        ]
        
        let jsonData = try JSONSerialization.data(withJSONObject: payload)
        let request = createRequest(path: "images/generations", method: "POST", body: jsonData)
        
        do {
            let (data, response) = try await urlSession.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw OpenAIError(error: .init(message: "Invalid response type", type: "invalid_response", param: nil, code: nil))
            }
            
            if httpResponse.statusCode != 200 {
                let errorData = try? JSONDecoder().decode(OpenAIError.self, from: data)
                throw OpenAIError(error: .init(
                    message: errorData?.error.message ?? "Image generation failed",
                    type: errorData?.error.type ?? "generation_error",
                    param: nil,
                    code: nil
                ))
            }
            
            struct ImageResponse: Codable {
                struct ImageData: Codable {
                    let url: String
                    let b64_json: String?
                }
                let created: Int
                let data: [ImageData]
            }
            
            let result = try JSONDecoder().decode(ImageResponse.self, from: data)
            guard let imageUrl = result.data.first?.url else {
                throw OpenAIError(error: .init(message: "No image URL in response", type: "invalid_response", param: nil, code: nil))
            }
            
            // Fetch the actual image data
            let (imageData, _) = try await urlSession.data(from: URL(string: imageUrl)!)
            log("✅ Successfully generated image")
            return imageData
        } catch {
            log("❌ Error generating image: \(error.localizedDescription)")
            throw error
        }
    }
    
    func createEmbedding(_ text: String) async throws -> [Float] {
        guard selectedModel.contains("text-embedding") else {
            throw OpenAIError(error: .init(message: "Selected model is not an embedding model", type: "invalid_model", param: nil, code: nil))
        }
        
        log("🧮 Creating embedding")
        log("📝 Input text: '\(text)'")
        
        let payload: [String: Any] = [
            "model": selectedModel,
            "input": text,
            "encoding_format": "float"
        ]
        
        let jsonData = try JSONSerialization.data(withJSONObject: payload)
        let request = createRequest(path: "embeddings", method: "POST", body: jsonData)
        
        do {
            let (data, response) = try await urlSession.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw OpenAIError(error: .init(message: "Invalid response type", type: "invalid_response", param: nil, code: nil))
            }
            
            if httpResponse.statusCode != 200 {
                let errorData = try? JSONDecoder().decode(OpenAIError.self, from: data)
                throw OpenAIError(error: .init(
                    message: errorData?.error.message ?? "Embedding creation failed",
                    type: errorData?.error.type ?? "embedding_error",
                    param: nil,
                    code: nil
                ))
            }
            
            struct EmbeddingResponse: Codable {
                struct EmbeddingData: Codable {
                    let embedding: [Float]
                }
                let data: [EmbeddingData]
            }
            
            let result = try JSONDecoder().decode(EmbeddingResponse.self, from: data)
            guard let embedding = result.data.first?.embedding else {
                throw OpenAIError(error: .init(message: "No embedding in response", type: "invalid_response", param: nil, code: nil))
            }
            
            log("✅ Successfully created embedding with \(embedding.count) dimensions")
            return embedding
        } catch {
            log("❌ Error creating embedding: \(error.localizedDescription)")
            throw error
        }
    }
    
    func generateSpeech(_ text: String, voice: String = "alloy", speed: Float = 1.0) async throws -> Data {
        guard selectedModel.contains("tts") else {
            throw OpenAIError(error: .init(message: "Selected model is not a text-to-speech model", type: "invalid_model", param: nil, code: nil))
        }
        
        log("🗣️ Generating speech")
        log("📝 Input text: '\(text)'")
        log("🎤 Voice: \(voice)")
        
        let payload: [String: Any] = [
            "model": selectedModel,
            "input": text,
            "voice": voice,
            "speed": speed
        ]
        
        let jsonData = try JSONSerialization.data(withJSONObject: payload)
        let request = createRequest(path: "audio/speech", method: "POST", body: jsonData)
        
        do {
            let (audioData, response) = try await urlSession.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw OpenAIError(error: .init(message: "Invalid response type", type: "invalid_response", param: nil, code: nil))
            }
            
            if httpResponse.statusCode != 200 {
                let errorData = try? JSONDecoder().decode(OpenAIError.self, from: audioData)
                throw OpenAIError(error: .init(
                    message: errorData?.error.message ?? "Speech generation failed",
                    type: errorData?.error.type ?? "speech_error",
                    param: nil,
                    code: nil
                ))
            }
            
            log("✅ Successfully generated speech audio")
            return audioData
        } catch {
            log("❌ Error generating speech: \(error.localizedDescription)")
            throw error
        }
    }
    
    func transcribeAudio(_ audioData: Data, language: String? = nil) async throws -> String {
        guard selectedModel.contains("whisper") else {
            throw OpenAIError(error: .init(message: "Selected model is not a speech-to-text model", type: "invalid_model", param: nil, code: nil))
        }
        
        log("👂 Transcribing audio")
        
        // Create multipart form data
        let boundary = UUID().uuidString
        var bodyData = Data()
        
        // Add model field
        bodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
        bodyData.append("Content-Disposition: form-data; name=\"model\"\r\n\r\n".data(using: .utf8)!)
        bodyData.append("\(selectedModel)\r\n".data(using: .utf8)!)
        
        // Add language field if specified
        if let language = language {
            bodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
            bodyData.append("Content-Disposition: form-data; name=\"language\"\r\n\r\n".data(using: .utf8)!)
            bodyData.append("\(language)\r\n".data(using: .utf8)!)
        }
        
        // Add file data
        bodyData.append("--\(boundary)\r\n".data(using: .utf8)!)
        bodyData.append("Content-Disposition: form-data; name=\"file\"; filename=\"audio.m4a\"\r\n".data(using: .utf8)!)
        bodyData.append("Content-Type: audio/m4a\r\n\r\n".data(using: .utf8)!)
        bodyData.append(audioData)
        bodyData.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        var request = createRequest(path: "audio/transcriptions", method: "POST")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = bodyData
        
        do {
            let (data, response) = try await urlSession.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw OpenAIError(error: .init(message: "Invalid response type", type: "invalid_response", param: nil, code: nil))
            }
            
            if httpResponse.statusCode != 200 {
                let errorData = try? JSONDecoder().decode(OpenAIError.self, from: data)
                throw OpenAIError(error: .init(
                    message: errorData?.error.message ?? "Transcription failed",
                    type: errorData?.error.type ?? "transcription_error",
                    param: nil,
                    code: nil
                ))
            }
            
            struct TranscriptionResponse: Codable {
                let text: String
            }
            
            let result = try JSONDecoder().decode(TranscriptionResponse.self, from: data)
            log("✅ Successfully transcribed audio")
            log("📝 Transcription: '\(result.text)'")
            return result.text
        } catch {
            log("❌ Error transcribing audio: \(error.localizedDescription)")
            throw error
        }
    }
    
    /// Converts text to speech using OpenAI's TTS API
    /// - Parameters:
    ///   - text: The text to convert to speech
    ///   - voice: The voice to use (alloy, echo, fable, onyx, nova, or shimmer)
    ///   - model: The model to use (currently only tts-1 and tts-1-hd are available)
    /// - Returns: Audio data in MP3 format
    func textToSpeech(
        text: String,
        voice: String = "alloy",
        model: String = "tts-1"
    ) async throws -> Data {
        log("🎤 Converting text to speech using voice: \(voice)")
        
        let payload: [String: Any] = [
            "model": model,
            "input": text,
            "voice": voice
        ]
        
        let jsonData = try JSONSerialization.data(withJSONObject: payload)
        let request = createRequest(path: "audio/speech", method: "POST", body: jsonData)
        
        do {
            let (audioData, response) = try await urlSession.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw OpenAIError(error: .init(message: "Invalid response type", type: "invalid_response", param: nil, code: nil))
            }
            
            if httpResponse.statusCode != 200 {
                let errorData = try? JSONDecoder().decode(OpenAIError.self, from: audioData)
                throw OpenAIError(error: .init(
                    message: errorData?.error.message ?? "Speech generation failed",
                    type: errorData?.error.type ?? "speech_error",
                    param: nil,
                    code: nil
                ))
            }
            
            log("✅ Successfully generated speech audio")
            return audioData
        } catch {
            log("❌ Error generating speech: \(error.localizedDescription)")
            throw error
        }
    }
}

// MARK: - Response Types

struct OpenAIResponse: Codable {
    struct Choice: Codable {
        struct Message: Codable {
            let content: String
        }
        let message: Message
        let finish_reason: String?
    }
    
    let id: String
    let choices: [Choice]
    let created: Int
    let model: String
    let usage: Usage?
}

struct Usage: Codable {
    let prompt_tokens: Int
    let completion_tokens: Int
    let total_tokens: Int
}

struct ModelsResponse: Codable {
    struct Model: Codable {
        let id: String
        let created: Int
        let owned_by: String
    }
    let data: [Model]
}

struct OpenAIError: Error, Codable {
    struct ErrorDetail: Codable {
        let message: String
        let type: String
        let param: String?
        let code: String?
    }
    let error: ErrorDetail
} 