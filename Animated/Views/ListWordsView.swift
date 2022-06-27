//
//  ListWordsView.swift
//  Animated
//
//  Created by Dang Hoang on 2022/06/05.
//

import SwiftUI
import CoreData

struct ListWordsView: View {
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    //@FetchRequest(sortDescriptors: [SortDescriptor(\.level, order: .reverse)]) var vocabularies: FetchedResults<Vocabulary>
    @FetchRequest(
        entity: Vocabulary.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath:
                                \Vocabulary.level, ascending: false)
    ])
    
    private var result: FetchedResults<Vocabulary>
    
    @State var showingAddView = false
    
    init(predicate: NSPredicate?){
        let fetchRequest = NSFetchRequest<Vocabulary>(entityName: Vocabulary.entity().name ?? "Vocabulary")
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath:
                                \Vocabulary.level, ascending: false)]
        if let predicate = predicate {
            fetchRequest.predicate = predicate
        }
        _result = FetchRequest(fetchRequest: fetchRequest)
    }
    
    private func deleteLanguage(offsets: IndexSet){
        offsets.forEach { index in
            let vocab = result[index]
            DataController().rememberWord(vocabulary: vocab, context: context)
        }
    }
    
    var body: some View {
        ZStack{
            
            Color("Background")
                .ignoresSafeArea()
            
            VStack(alignment:.leading){
                SearchBarView()
                NavigationView {
                    List {
                        ForEach(result) { word in
                            NavigationLink(destination: WordDetailView(vocabulary: word)){
                                HStack(spacing: 20){
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(word.word!)
                                            .customFont(.title2)
                                        Text(word.type!)
                                            .customFont(.body)
                                    }
                                    Divider()
                                    Image(systemName: "square.and.pencil")
                                }
                                .padding(10)
                                .frame(maxWidth: .infinity, maxHeight: 80)
                                .background(LinearGradient(colors: [Color(hex: "ffecd2"), Color(hex: "fcb69f")], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .foregroundColor(.white)
                                .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
                            }
                        }
                        .onDelete(perform: deleteLanguage)
                    }
                    .navigationTitle("Words")
                    .listStyle(.plain)
                }
            }
            .padding()
            .sheet(isPresented: $showingAddView) {
                AddNewWordView()
            }
            
            Image(systemName: "plus.circle")
                .frame(width: 36, height: 36)
                .background(.white)
                .mask(Circle())
                .shadow(color: Color("Shadow").opacity(0.2), radius: 5, x: 0, y: 5)
                .onTapGesture {
                    withAnimation(.spring()) {
                        showingAddView.toggle()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding()
                .offset(y: -60)
                .offset(x: showingAddView ? 200 : 0)
        }
    }
}

struct ListWordsView_Previews: PreviewProvider {
    static var previews: some View {
        ListWordsView(predicate: nil)
    }
}
