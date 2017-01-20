//
//  Question+CoreDataProperties.swift
//  iOSFact
//
//  Created by James Daniell on 20/01/2017.
//  Copyright © 2017 JamesDaniell. All rights reserved.
//

import Foundation
import CoreData


extension Question {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Question> {
        return NSFetchRequest<Question>(entityName: "Question");
    }

    @NSManaged public var answerContent: String?
    @NSManaged public var correctNeeded: Int16
    @NSManaged public var examDate: NSDate?
    @NSManaged public var questionContent: String?
    @NSManaged public var nextDate: NSDate?
    @NSManaged public var subject: Subject?

}
