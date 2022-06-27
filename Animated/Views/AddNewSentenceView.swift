//
//  AddNewSentenceView.swift
//  Animated
//
//  Created by Dang Hoang on 2022/06/06.
//

import SwiftUI

struct AddNewSentenceView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    @State var word : Vocabulary
    @State private var sentence = ""
    
    var body: some View {
        NavigationView{
            Form {
                Section {
                    
                    TextField("sentence", text: $sentence)
                    
                    Divider()
                    HStack{
                        Spacer()
                        Button("Summit"){
                            if (!sentence.isEmpty){
                                DataController().addSentence(sentence: sentence, vocabulary: word, context: managedObjContext)
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

struct AddNewSentenceView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewSentenceView(word: Vocabulary())
    }
}
