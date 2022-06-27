//
//  Sentence+CoreDataProperties.swift
//  Animated
//
//  Created by Dang Hoang on 2022/06/05.
//
//

import Foundation
import CoreData


extension Sentence {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Sentence> {
        return NSFetchRequest<Sentence>(entityName: "Sentence")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var sentence: String?
    @NSManaged public var vocabulary: Vocabulary?
    
    static func predicate(with vocabulary: Vocabulary) -> NSPredicate? {
        var predicate = [NSPredicate]()
        
        predicate.append(NSPredicate(format: "vocabulary == \(vocabulary)"))
        
        if predicate.isEmpty {
            return nil
        } else {
            return NSCompoundPredicate(andPredicateWithSubpredicates: predicate)
        }
    }

}



extension Sentence : Identifiable {

}
