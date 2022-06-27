//
//  WordDetailView.swift
//  Animated
//
//  Created by Dang Hoang on 2022/06/05.
//

import SwiftUI
import CoreData

struct WordDetailView: View {
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    @FetchRequest(
        entity: Sentence.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath:
                                \Sentence.id, ascending: false)
    ])
    
    private var result: FetchedResults<Sentence>
    @State var showingAddView: Bool = false
    private var vocab : Vocabulary
    init(vocabulary: Vocabulary){
        self.vocab = vocabulary
        let fetchRequest = NSFetchRequest<Sentence>(entityName: Sentence.entity().name ?? "Sentence")
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath:
                                \Sentence.id, ascending: false)]
        fetchRequest.predicate  = NSPredicate(format: "vocabulary == %@", vocabulary)
        _result = FetchRequest(fetchRequest: fetchRequest)
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment:.leading){
                ForEach(result) { senten in
                    Text(senten.sentence!)
                        .customFont(.body)
                        .padding()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddView.toggle()
                    } label: {
                        Label("Add", systemImage: "plus.circle")
                            .frame(width: 48, height: 48)
                    }
                }
            }.sheet(isPresented: $showingAddView) {
                AddNewSentenceView(word: vocab)
            }
        }
    }
}

struct WordDetailView_Previews: PreviewProvider {
    static var previews: some View {
        WordDetailView(vocabulary: Vocabulary())
    }
}
