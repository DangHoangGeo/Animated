//
//  FlashCardView.swift
//  Animated
//
//  Created by Dang Hoang on 2022/06/01.
//

import SwiftUI
import RiveRuntime
import AVFoundation

struct FlashCard: View {
    @State var translation: CGSize = .zero
    @State var swipeStatus: RememberAndNope = .none
    @State var isTabed: Bool = false
    @Binding var isRemember: Int
    var vocabulary: EnglishVocabulary
    var onRemove: (_ vocabulary: EnglishVocabulary) -> Void
    
    var thresholdPercentage: CGFloat = 0.4
    let language: String = "en-US"
    let speakRate: Float = 0.5
    let icon = RiveViewModel(fileName: "icons", stateMachineName: "AUDIO_Interactivity", artboardName: "AUDIO")
    
    /*init(vocabulary: EnglishVocabulary, isRemember: Int, onRemove: @escaping (_ vocabulary: EnglishVocabulary) -> Void) {
        self.vocabulary = vocabulary
        self.onRemove = onRemove
    }*/
    
    //Percentage of width have we swipped
    //Parameters:
    //geometry: The geometry
    //gesture: The current gesture translation value
    
    private func getGesturePercentage(_ geometry: GeometryProxy, from gesture: DragGesture.Value) -> CGFloat {
        gesture.translation.width / geometry.size.width
    }
    
    private func speakWord(word: String) {
        try? icon.setInput("active", value: true)
        let utterance = AVSpeechUtterance(string: vocabulary.word)
        //TODO: get language voice from user's setting value.
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        utterance.rate = speakRate
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            try? icon.setInput("active", value: false)
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading){
                ZStack(alignment: self.swipeStatus == .remember ? .topLeading : .topTrailing){
                    if isTabed {
                        backView
                    }else {
                        frontView
                            
                    }
                    
                    if self.swipeStatus == .remember {
                        Text("Got it").bold()
                            .customFont(.title2)
                            .padding()
                            .cornerRadius(10)
                            .foregroundColor(Color.green)
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.green, lineWidth: 4.0)
                            ).padding(24)
                            .rotationEffect(Angle.degrees(-45))
                        
                    } else if self.swipeStatus == .nopes {
                        Text("Try later").bold()
                            .customFont(.headline)
                            .padding()
                            .cornerRadius(10)
                            .foregroundColor(Color.red)
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.red, lineWidth: 4.0)
                            ).padding(24)
                            .rotationEffect(Angle.degrees(45))
                    }
                    
                }
            }
            .background(Color.white)
            .cornerRadius(30)
            .shadow(color: Color("Shadow").opacity(0.4), radius: 5, x: 0, y: 4)
            .animation(_:.interactiveSpring())
            .offset(x: self.translation.width, y: 0)
            .rotationEffect(.degrees(Double(self.translation.width / geometry.size.width) * 25), anchor: .bottom)
            .gesture(
                 DragGesture()
                     .onChanged { value in
                         self.translation = value.translation
                         
                         if (self.getGesturePercentage(geometry, from: value)) >= self.thresholdPercentage {
                             self.swipeStatus = .remember
                         } else if self.getGesturePercentage(geometry, from: value) <= -self.thresholdPercentage {
                             self.swipeStatus = .nopes
                         } else {
                             self.swipeStatus = .none
                         }
                     }
                     .onEnded { value in
                         // snap distance > 0.5 half the width of the screen
                         if abs(self.getGesturePercentage(geometry, from: value)) > self.thresholdPercentage {
                             self.onRemove(self.vocabulary)
                         } else {
                             self.translation = .zero
                         }
                         if self.swipeStatus == .remember {
                             self.isRemember += 1
                         }
                     }
             )
        }
    }
    
    var frontView: some View {
        VStack(spacing: 8) {
            HStack(spacing: 12) {
                ForEach(vocabulary.type) { item in
                    Text(item.type.rawValue)
                        .opacity(0.7)
                    .frame(alignment: .leading)
                }
                Spacer()
                icon.view()
                    .frame(width: 38, height: 38)
                    //.frame(maxWidth: .infinity, alignment: .topTrailing)
                    .onTapGesture {
                        speakWord(word: vocabulary.word)
                    }
            }
            Text(vocabulary.word)
                .customFont(.largeTitle)
                .frame(maxWidth: .infinity, maxHeight: 120, alignment: .center)
                .padding(.top, 10)
                .onTapGesture {
                    speakWord(word: vocabulary.word)
                }
            Spacer()
            VStack(alignment: .leading, spacing: 4){
                ForEach(vocabulary.relatedWords, id: \.self) { related in
                        Text(related)
                            .customFont(.footnote)
                            .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
        }
        .foregroundColor(.white)
        .padding(20)
        .frame(width: 340, height: 320)
        .background(.linearGradient(colors:[Color(hex: "a6c1ee"), Color(hex: "fbc2eb").opacity(1)], startPoint: .top, endPoint: .bottom))
        .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .shadow(color: Color(hex: "fbc2eb").opacity(0.9), radius: 8, x: 0, y: 12)
        .shadow(color: Color(hex: "fbc2eb").opacity(0.4), radius: 2, x: 0, y: 1)
        .onTapGesture {
            withAnimation(.interactiveSpring()) {
                isTabed.toggle()
            }
        }
    }
    
    var backView: some View {
        VStack {
            Text(vocabulary.word)
                .customFont(.title)
                .frame(maxWidth: .infinity, maxHeight: 50, alignment: .center)
            
            VStack(alignment: .leading, spacing: 10) {
                ForEach(vocabulary.type) { item in
                    HStack{
                        Text(item.type.rawValue)
                            .customFont(.footnote)
                        Spacer()
                        Text(item.define)
                            .customFont(.footnote)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            
            VStack(alignment: .leading, spacing: 10) {
                ForEach(vocabulary.sentences, id: \.self) { sentence in
                    Text(sentence)
                        .customFont(.body)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 10)
            
            Spacer()
        }
        .foregroundColor(.white)
        .padding(20)
        .frame(width: 340, height: 320)
        .background(.linearGradient(colors:[Color(hex: "fccb90"), Color(hex: "d57eeb").opacity(0.8)], startPoint: .topTrailing, endPoint: .bottom))
        .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .shadow(color: Color(hex: "d57eeb").opacity(0.9), radius: 8, x: 0, y: 12)
        .shadow(color: Color(hex: "d57eeb").opacity(0.4), radius: 2, x: 0, y: 1)
        .onTapGesture {
            withAnimation(.interactiveSpring()) {
                isTabed.toggle()
            }
        }
        
    }
}

struct FlashCard_Previews: PreviewProvider {
    static var previews: some View {
        FlashCard(isRemember: .constant(0), vocabulary: sampleEnglishVocabularies[0],  onRemove: { _ in
                // do nothing
        })
        .frame(height: 300)
        .padding()
    }
}
