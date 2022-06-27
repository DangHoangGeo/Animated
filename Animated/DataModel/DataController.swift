//
//  DataController.swift
//  Animated
//
//  Created by Dang Hoang on 2022/06/03.
//

import Foundation
import CoreData

class DataController : ObservableObject {
    let container = NSPersistentContainer(name: "LanguageModel")
    
    init(){
        container.loadPersistentStores{ desc, error in
            if let error = error {
                print("Failed to load the data \(error.localizedDescription)")
            }
        }
    }
    
    func save(context: NSManagedObjectContext){
        do {
            try context.save()
            print("Data saved!!")
        } catch {
            print("We could not save the data...")
        }
    }
    
    func addVocabulary(word: String, type: String, level: String, watch: Int16, context: NSManagedObjectContext) -> Vocabulary {
        let vocabulary = Vocabulary(context: context)
        vocabulary.id = UUID()
        vocabulary.word = word
        vocabulary.type = type
        vocabulary.level = level
        
        save(context: context)
        return vocabulary
    }
    
    func editVocabulary(vocabulary: Vocabulary, word: String, type: String, remember: Bool, level: String, watch: Int16, context: NSManagedObjectContext){
        vocabulary.word = word
        vocabulary.type = type
        vocabulary.remember = remember
        vocabulary.level = level
        vocabulary.watch = watch
        save(context: context)
    }
    
    func rememberWord(vocabulary:Vocabulary, context: NSManagedObjectContext){
        vocabulary.remember = true
        save(context: context)
    }
    
    func addSentence(sentence: String, vocabulary: Vocabulary ,context: NSManagedObjectContext){
        let senten = Sentence(context: context)
        senten.id = UUID()
        senten.sentence = sentence
        senten.vocabulary = vocabulary
        
        save(context: context)
    }
    
    func addTypeDefine(type: String, define: String, vocabulary: Vocabulary ,context: NSManagedObjectContext){
        let typeD = TypeDefine(context: context)
        typeD.id = UUID()
        typeD.type = type
        typeD.define = define
        typeD.vocabulary = vocabulary
        
        save(context: context)
    }
    
}
