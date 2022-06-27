//
//  EnglishVocabulary.swift
//  Animated
//
//  Created by Dang Hoang on 2022/06/01.
//

import SwiftUI

enum Level: String, CaseIterable {
    case novice
    case amateur
    case learner
    case skilled
    case expert
    case master
}

extension Level: Identifiable {
    var id: String {rawValue}
}

enum Sequence: Int, CaseIterable {
    case s1 = 1
    case s2 = 2
    case s3 = 3
    case s4 = 4
    case s5 = 5
    case s6 = 6
    case s7 = 7
    case s8 = 8
    case s9 = 9
    
    var localizedName: LocalizedStringKey { LocalizedStringKey(String(rawValue)) }
}

extension Sequence: Identifiable {
    var id: Int { rawValue }
}

enum WordType: String, CaseIterable  {
    case noun
    case pronoun
    case verb
    case adjective
    case adverb
    case preposition
    case conjunction
    case interjection
}

extension WordType: Identifiable {
    var id: String { rawValue }
}

struct TypeDefineN: Identifiable{
    var id = UUID()
    var type: WordType
    var define: String
}

struct EnglishVocabulary: Identifiable{
    var id = UUID()
    var word: String
    var type: [TypeDefineN]
    var level: Level
    var relatedWords: [String]
    var sentences: [String]
    var sequence: Sequence
}

var sampleEnglishVocabularies: [EnglishVocabulary] = [
    EnglishVocabulary(word: "assurance", type: [TypeDefineN(type: .noun, define: "a binding commitment to do or give or refrain from something")], level: .master, relatedWords: ["authority", "confidence", "self-assurance", "self-confidence", "sureness"], sentences: ["an assurance of help when needed", "the Presidents assurances were not respected"], sequence: .s1),
    EnglishVocabulary(word: "establish", type: [TypeDefineN(type: .verb, define: "set up or found"), TypeDefineN(type: .verb, define: "institute, enact, or establish")], level: .master, relatedWords: ["authority, confidence, self-assurance, self-confidence, sureness"], sentences: ["establish a new department","establish as the highest level or best performance"], sequence: .s2),
    EnglishVocabulary(word: "obligation", type: [TypeDefineN(type: .noun, define: "the state of being bound to do or pay something")], level: .skilled, relatedWords: ["duty, responsibility, certificate of indebtedness, debt instrument"], sentences: ["he is under an obligation to finish the job"], sequence: .s3),
    EnglishVocabulary(word: "provision", type: [TypeDefineN(type: .noun, define: "the activity of supplying or providing something"), TypeDefineN(type: .verb, define: "supply with provisions")], level: .skilled, relatedWords: ["supply, supplying, planning, preparation"], sentences: ["he accepted subject to one provision"], sequence: .s4),
    EnglishVocabulary(word: "convince", type: [TypeDefineN(type: .verb, define: "make (someone) agree, understand, or realize the truth or validity of something")], level: .skilled, relatedWords: ["convert, win over"], sentences: ["He had finally convinced several customers of the advantages of his product"], sequence: .s5),
]
