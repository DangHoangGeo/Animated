//
//  FlashCardView.swift
//  Animated
//
//  Created by Dang Hoang on 2022/06/01.
//

import SwiftUI
import Speech
import AVFoundation
import RiveRuntime

struct FlashCardView: View {
    @EnvironmentObject var speechRecognizer : SpeechRecognizer
    @State var englishVocab: [EnglishVocabulary] = sampleEnglishVocabularies
    @State var isRemember = 0
    
    private func getCardWidth(_ geometry: GeometryProxy, sequence: Int) -> CGFloat {
        let offset: CGFloat = CGFloat(englishVocab.count - 1 - sequence) * 6
        return geometry.size.width - offset
    }
    
    private func getCardOffset(_ geometry: GeometryProxy, sequence: Int) -> CGFloat {
        return CGFloat(self.englishVocab.count - 1 - sequence) * 6
    }
    
    private var maxID: Int {
        return self.englishVocab.map {$0.sequence.rawValue}.max() ?? 0
    }
    
    var body: some View {
        ZStack{
            Color("Background").ignoresSafeArea()
            background
            VStack {
                GeometryReader { geometry in
                    VStack(spacing: 24){
                        TopView(count: isRemember)
                        ZStack {
                            ForEach(englishVocab, id: \.id) { word in
                                if (self.maxID - 3)...self.maxID ~= Int(word.sequence.rawValue) {
                                    FlashCard(isRemember: $isRemember, vocabulary: word, onRemove: { removeWord in
                                        englishVocab.removeAll() { $0.id == removeWord.id }
                                        })
                                    .frame(width: self.getCardWidth(geometry, sequence: word.sequence.rawValue), height: 400)
                                    .offset(x: 0, y: self.getCardOffset(geometry, sequence: word.sequence.rawValue))
                                }
                            }
                        }
                        
                        VStack {
                            FavView(text:speechRecognizer.textResult)
                            
                            VStack{
                                Image(systemName: speechRecognizer.buttonText )
                                    .frame(width: 44, height: 44)
                                    .onTapGesture {
                                        speechRecognizer.recordButtonTapped()
                                    }
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.white.opacity(0.1))
                                    .clipShape(Circle())
                            }
                            .clipShape(Circle())
                            .background(speechRecognizer.recordButton == .unable ? Color(hex: "787B82").opacity(0.3) : Color.red.opacity(0.8))
                            .cornerRadius(50)
                            .shadow(color: Color("Background 2").opacity(0.5), radius: 10, x: 0, y: 5)
                        }
                        Spacer()
                    }
                    
                }
            }
            .padding()
            /*.background(
                Image("Spline")
                    .blur(radius: 60)
                    .offset(x:0, y:300)
            )*/
        }
    }
    
    var background: some View {
        RiveViewModel(fileName: "myshapes").view()
            .ignoresSafeArea()
            .blur(radius: 50)
            .background(
                Image("Spline")
                    .blur(radius: 100)
                    .offset(x:200, y:100)
        )
    }
}

struct FlashCardView_Previews: PreviewProvider {
    static var previews: some View {
        FlashCardView()
            .environmentObject(SpeechRecognizer())
    }
}

struct TopView: View {
    
    let date: Date
    let dateFormatter: DateFormatter
    public var count : Int
    
    init(count: Int){
        date = Date()
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, dd MMM"
        self.count = count
    }
    
    var body: some View {
        VStack {
            
            HStack {
                VStack(alignment: .leading) {
                    Text(dateFormatter.string(from: date))
                        .font(.title)
                        .bold()
                }
                Spacer()
                HStack {
                    
                    Text("Got: ")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text("\(count)").font(.headline)
                }
            }
            .padding()
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct FavView: View {
    public var text : String = ""
    var body: some View {
        VStack {
            HStack {
                Text(text)
                    .customFont(.body)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.white)
            }.padding()
        }
        .background(.white.opacity(0.2))
        //.background(.ultraThinMaterial)
        .mask(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .shadow(color: Color("Background 2").opacity(0.6), radius: 10, x: 0, y: 10)
        .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous)
            .stroke(.linearGradient(colors: [.white.opacity(0.2), .white.opacity(0)], startPoint: .topLeading, endPoint: .bottomTrailing)))
    }
}

class SpeechRecognizer: ObservableObject { //: NSObject, SFSpeechRecognizerDelegate {
    // MARK: Properties
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
    private var recognitionTask: SFSpeechRecognitionTask?
    
    private let audioEngine = AVAudioEngine()
    
    private let synthesizer = AVSpeechSynthesizer()
    
    @Published var textResult : String = "Try your voice!"
    
    @Published var buttonText : String = "mic.slash"
    
    @Published var recordButton : RecodingState = .unable
    
    init(){
        
        // Configure the SFSpeechRecognizer object already
        // stored in a local member variable.
        //speechRecognizer.delegate = self
        
        SFSpeechRecognizer.requestAuthorization { authStatus in

            // Divert to the app's main thread so that the UI
            // can be updated.
            
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.recordButton = .unable
                    self.buttonText = "mic.slash"
                    
                case .denied:
                    self.recordButton = .unable
                    self.buttonText = "mic.slash.fill"
                    
                case .restricted:
                    self.recordButton = .unable
                    self.buttonText = "mic.slash.fill"
                    
                case .notDetermined:
                    self.recordButton = .unable
                    self.buttonText = "mic.slash.fill"
                    
                default:
                    self.recordButton = .unable
                }
            }
        }
    }

    private func startRecording() throws {
        
        // Cancel the previous task if it's running.
        recognitionTask?.cancel()
        self.recognitionTask = nil
        
        // Configure the audio session for the app.
        let audioSession = AVAudioSession.sharedInstance()
        do {
            //try audioSession.setCategory(AVAudioSession.Category.playAndRecord)
            //try audioSession.setActive(false, options: .notifyOthersOnDeactivation)
            try audioSession.setCategory(.playAndRecord, mode: .spokenAudio, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            } catch {
                // handle errors
            }
        let inputNode = audioEngine.inputNode

        // Create and configure the speech recognition request.
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object") }
        recognitionRequest.shouldReportPartialResults = true
        
        // Keep speech recognition data on device
        if #available(iOS 15.4, *) {
            recognitionRequest.requiresOnDeviceRecognition = false
        }
        
        // Create a recognition task for the speech recognition session.
        // Keep a reference to the task so that it can be canceled.
        self.recordButton = .processing
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            
            if let result = result {
                // Update the text view with the results.
                self.textResult = result.bestTranscription.formattedString
                isFinal = result.isFinal
                //print("Text \(result.bestTranscription.formattedString)")
                //self.recordButton = .stoped
                // TODO: COMPARE RESULT WITH THE TEXT
                self.audioEngine.stop()
                self.recognitionRequest?.endAudio()
                self.recordButton = .unable
                self.buttonText = "mic.slash"
                //self.textResult = "Try your voice!"
            }
            
            if error != nil || isFinal {
                // Stop recognizing speech if there is a problem.
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)

                self.recognitionRequest = nil
                self.recognitionTask = nil

                self.recordButton = .unable
                self.buttonText = "mic.slash"
            }
           /* do{
                let _ = try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
              }catch{
                  print(error)
              }
            */
        }

        // Configure the microphone input.
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        
        // Let the user know to start talking.
        self.textResult = "I'm listening..."
    }
    
    // MARK: SFSpeechRecognizerDelegate
    
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            recordButton = .able
            buttonText = "mic.slash"
        } else {
            recordButton = .unable
            buttonText = "Recognition Not Available"
        }
    }
    
    // MARK: Interface Builder actions
    
    public func recordButtonTapped() {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            recordButton = .unable
            buttonText = "mic.slash"
            self.textResult = "Try your voice!"
        } else {
            do {
                try startRecording()
                buttonText = "mic"
            } catch {
                buttonText = "mic.slash.fill"
            }
        }
    }
}
