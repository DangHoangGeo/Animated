//
//  Answer+CoreDataProperties.swift
//  Animated
//
//  Created by Dang Hoang on 2022/06/05.
//
//

import Foundation
import CoreData


extension Answer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Answer> {
        return NSFetchRequest<Answer>(entityName: "Answer")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var answer: String?
    @NSManaged public var isAnswer: Bool
    @NSManaged public var chosen: Int16
    @NSManaged public var priority: Int16

}

extension Answer : Identifiable {

}
