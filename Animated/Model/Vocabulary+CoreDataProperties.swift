//
//  Vocabulary+CoreDataProperties.swift
//  Animated
//
//  Created by Dang Hoang on 2022/06/05.
//
//

import Foundation
import CoreData


extension Vocabulary {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Vocabulary> {
        return NSFetchRequest<Vocabulary>(entityName: "Vocabulary")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var word: String?
    @NSManaged public var level: String?
    @NSManaged public var type: String?
    @NSManaged public var remember: Bool
    @NSManaged public var watch: Int16
    @NSManaged public var sentences: NSSet?
    @NSManaged public var typeDefines: NSSet?

}

// MARK: Generated accessors for sentences
extension Vocabulary {

    @objc(addSentencesObject:)
    @NSManaged public func addToSentences(_ value: Sentence)

    @objc(removeSentencesObject:)
    @NSManaged public func removeFromSentences(_ value: Sentence)

    @objc(addSentences:)
    @NSManaged public func addToSentences(_ values: NSSet)

    @objc(removeSentences:)
    @NSManaged public func removeFromSentences(_ values: NSSet)

}

// MARK: Generated accessors for typeDefines
extension Vocabulary {

    @objc(addTypeDefinesObject:)
    @NSManaged public func addToTypeDefines(_ value: TypeDefine)

    @objc(removeTypeDefinesObject:)
    @NSManaged public func removeFromTypeDefines(_ value: TypeDefine)

    @objc(addTypeDefines:)
    @NSManaged public func addToTypeDefines(_ values: NSSet)

    @objc(removeTypeDefines:)
    @NSManaged public func removeFromTypeDefines(_ values: NSSet)

}

extension Vocabulary {
    
    static func pridicate(with isRemember: Bool) -> NSPredicate? {
        var predicates = [NSPredicate]()
        predicates.append(NSPredicate(format: "remember == \(isRemember ? "YES" : "NO")"))
        if predicates.isEmpty {
            return nil
        } else {
            return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        }
    }
}

extension Vocabulary : Identifiable {

}
