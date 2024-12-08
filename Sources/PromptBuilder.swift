import SwiftUI

struct PromptBuilder: View {
    @Binding var generatedPrompt: String
    @State private var tone = "Professional"
    @State private var style = "Concise"
    @State private var purpose = "General"
    @State private var formality = "Standard"
    
    private let tones = ["Professional", "Casual", "Friendly", "Technical", "Academic"]
    private let styles = ["Concise", "Detailed", "Simple", "Comprehensive"]
    private let purposes = ["General", "Business", "Technical", "Creative", "Academic"]
    private let formalities = ["Standard", "Formal", "Informal", "Semi-formal"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Smart Prompt Builder")
                .font(.headline)
                .padding(.bottom, 5)
            
            Group {
                Picker("Tone", selection: $tone) {
                    ForEach(tones, id: \.self) { tone in
                        Text(tone).tag(tone)
                    }
                }
                .pickerStyle(.menu)
                
                Picker("Style", selection: $style) {
                    ForEach(styles, id: \.self) { style in
                        Text(style).tag(style)
                    }
                }
                .pickerStyle(.menu)
                
                Picker("Purpose", selection: $purpose) {
                    ForEach(purposes, id: \.self) { purpose in
                        Text(purpose).tag(purpose)
                    }
                }
                .pickerStyle(.menu)
                
                Picker("Formality", selection: $formality) {
                    ForEach(formalities, id: \.self) { formality in
                        Text(formality).tag(formality)
                    }
                }
                .pickerStyle(.menu)
            }
            
            Button("Generate Prompt") {
                generatedPrompt = generatePrompt()
            }
            .buttonStyle(.borderedProminent)
            
            Text("Note: Generated prompts are suggestions only. Feel free to modify them.")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
    }
    
    private func generatePrompt() -> String {
        """
        You are a text improvement assistant with the following characteristics:
        - Tone: \(tone.lowercased())
        - Style: \(style.lowercased())
        - Purpose: \(purpose.lowercased()) content
        - Formality: \(formality.lowercased()) language
        
        Your task is to:
        1. Improve grammar and clarity
        2. Maintain the intended meaning
        3. Adjust tone and style as specified
        4. Ensure proper punctuation and formatting
        5. Keep the text natural and fluent
        
        Please improve the provided text while following these guidelines.
        """
    }
} 