//
//  AddNewWordView.swift
//  Animated
//
//  Created by Dang Hoang on 2022/06/03.
//

import SwiftUI

struct AddNewWordView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    @State private var word = ""
    @State private var level: Level = .amateur
    @State private var type: WordType = .noun
    @State private var seqence: Sequence = .s1
    @State private var sentence = ""
    @State private var typeDefine = ""
    @State private var watch = 0
    @State private var date = Date()
    
    var body: some View {
        NavigationView{
            Form {
                Section {
                    TextField("Word", text: $word)
                    
                    Picker(selection: $level) {
                        ForEach(Level.allCases) { level in
                            Text(level.rawValue.capitalized).tag(level)
                        }
                    } label: {
                        Text("Level")
                    }
                    
                    Picker(selection: $type, label: Text("Type")) {
                        ForEach(WordType.allCases) { wordType in
                            Text(wordType.rawValue.capitalized).tag(wordType)
                        }
                    }
                    
                    Picker(selection: $seqence) {
                        ForEach(Sequence.allCases) { sequen in
                            Text(sequen.localizedName).tag(sequen)
                        }
                    } label: {
                        Text("Sequence")
                    }
                    
                    TextField("Type define", text: $typeDefine)
                    
                    TextField("sentence", text: $sentence)
                    
                    Divider()
                    HStack{
                        Spacer()
                        Button("Summit"){
                            let vocabulary = DataController().addVocabulary(word: word, type: type.rawValue, level: level.rawValue, watch: Int16(watch), context: managedObjContext)
                            
                            if (!sentence.isEmpty){
                                DataController().addSentence(sentence: sentence, vocabulary: vocabulary, context: managedObjContext)
                            }
                            if (!typeDefine.isEmpty){
                                DataController().addTypeDefine(type: type.rawValue, define: typeDefine, vocabulary: vocabulary, context: managedObjContext)
                            }
                            dismiss()
                        }
                        Spacer()
                    }
                }
            }
            .navigationBarTitle("Add new word")
        }
    }
}

struct AddNewWordView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewWordView()
    }
}
