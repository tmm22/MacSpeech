import Foundation
import AVFoundation
import Speech

class AudioRecorder: NSObject, ObservableObject, AVCaptureAudioDataOutputSampleBufferDelegate {
    @Published var isRecording = false
    @Published var audioURL: URL?
    @Published var permissionGranted = false
    @Published var permissionError: String?
    
    private var captureSession: AVCaptureSession?
    private var audioOutput: AVCaptureAudioDataOutput?
    private var audioWriter: AVAssetWriter?
    private var audioInput: AVAssetWriterInput?
    private var startTime: CMTime?
    
    override init() {
        super.init()
        // Don't check permissions immediately, wait for user action
    }
    
    func requestPermissions() {
        // Check microphone permission
        switch AVCaptureDevice.authorizationStatus(for: .audio) {
        case .authorized:
            checkSpeechPermission()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .audio) { [weak self] granted in
                if granted {
                    self?.checkSpeechPermission()
                } else {
                    DispatchQueue.main.async {
                        self?.permissionGranted = false
                        self?.permissionError = "Microphone access denied"
                    }
                }
            }
        case .denied:
            DispatchQueue.main.async {
                self.permissionGranted = false
                self.permissionError = "Microphone access denied. Please grant access in System Settings."
            }
        case .restricted:
            DispatchQueue.main.async {
                self.permissionGranted = false
                self.permissionError = "Microphone access restricted"
            }
        @unknown default:
            DispatchQueue.main.async {
                self.permissionGranted = false
                self.permissionError = "Unknown permission status"
            }
        }
    }
    
    private func checkSpeechPermission() {
        SFSpeechRecognizer.requestAuthorization { [weak self] status in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    self?.permissionGranted = true
                    self?.permissionError = nil
                    self?.setupCaptureSession()
                case .denied:
                    self?.permissionGranted = false
                    self?.permissionError = "Speech recognition access denied"
                case .restricted:
                    self?.permissionGranted = false
                    self?.permissionError = "Speech recognition access restricted"
                case .notDetermined:
                    self?.permissionGranted = false
                    self?.permissionError = "Speech recognition access not determined"
                @unknown default:
                    self?.permissionGranted = false
                    self?.permissionError = "Unknown speech recognition status"
                }
            }
        }
    }
    
    private func setupCaptureSession() {
        captureSession = AVCaptureSession()
        
        guard let audioDevice = AVCaptureDevice.default(for: .audio) else {
            DispatchQueue.main.async {
                self.permissionError = "No audio device available"
            }
            return
        }
        
        do {
            let audioInput = try AVCaptureDeviceInput(device: audioDevice)
            if captureSession?.canAddInput(audioInput) ?? false {
                captureSession?.addInput(audioInput)
            } else {
                DispatchQueue.main.async {
                    self.permissionError = "Cannot add audio input to session"
                }
                return
            }
            
            audioOutput = AVCaptureAudioDataOutput()
            if let audioOutput = audioOutput,
               captureSession?.canAddOutput(audioOutput) ?? false {
                captureSession?.addOutput(audioOutput)
                let queue = DispatchQueue(label: "audio.recording.queue")
                audioOutput.setSampleBufferDelegate(self, queue: queue)
            } else {
                DispatchQueue.main.async {
                    self.permissionError = "Cannot add audio output to session"
                }
                return
            }
        } catch {
            DispatchQueue.main.async {
                self.permissionError = "Error setting up audio capture: \(error.localizedDescription)"
            }
        }
    }
    
    func startRecording() {
        guard permissionGranted else {
            requestPermissions()
            return
        }
        
        let audioFilename = FileManager.default.temporaryDirectory.appendingPathComponent("recording.m4a")
        audioURL = audioFilename
        
        do {
            audioWriter = try AVAssetWriter(url: audioFilename, fileType: .m4a)
            
            let audioSettings: [String: Any] = [
                AVFormatIDKey: kAudioFormatMPEG4AAC,
                AVSampleRateKey: 44100.0,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            audioInput = AVAssetWriterInput(mediaType: .audio, outputSettings: audioSettings)
            audioInput?.expectsMediaDataInRealTime = true
            
            if let audioInput = audioInput,
               audioWriter?.canAdd(audioInput) ?? false {
                audioWriter?.add(audioInput)
            }
            
            captureSession?.startRunning()
            isRecording = true
            startTime = nil
        } catch {
            DispatchQueue.main.async {
                self.permissionError = "Failed to start recording: \(error.localizedDescription)"
            }
        }
    }
    
    func stopRecording() {
        captureSession?.stopRunning()
        audioInput?.markAsFinished()
        audioWriter?.finishWriting { [weak self] in
            DispatchQueue.main.async {
                self?.isRecording = false
            }
        }
    }
    
    func getAudioData() -> Data? {
        guard let url = audioURL else { return nil }
        return try? Data(contentsOf: url)
    }
    
    func cleanup() {
        if let url = audioURL {
            try? FileManager.default.removeItem(at: url)
            audioURL = nil
        }
    }
    
    // MARK: - AVCaptureAudioDataOutputSampleBufferDelegate
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard isRecording,
              let audioWriter = audioWriter,
              let audioInput = audioInput else { return }
        
        if startTime == nil {
            startTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
            audioWriter.startWriting()
            audioWriter.startSession(atSourceTime: startTime!)
        }
        
        if audioInput.isReadyForMoreMediaData {
            audioInput.append(sampleBuffer)
        }
    }
} 