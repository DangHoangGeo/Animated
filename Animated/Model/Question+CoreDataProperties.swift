//
//  Question+CoreDataProperties.swift
//  Animated
//
//  Created by Dang Hoang on 2022/06/05.
//
//

import Foundation
import CoreData


extension Question {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Question> {
        return NSFetchRequest<Question>(entityName: "Question")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var question: String?
    @NSManaged public var level: String?
    @NSManaged public var pass: Bool
    @NSManaged public var repeatNum: Int16
    @NSManaged public var pass_date: Date?
    @NSManaged public var answer: Answer?

}

extension Question : Identifiable {

}
