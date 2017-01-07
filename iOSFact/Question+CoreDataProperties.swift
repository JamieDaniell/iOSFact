



//
//  Question+CoreDataProperties.swift
//  iOSFact
//
//  Created by James Daniell on 06/01/2017.
//  Copyright © 2017 JamesDaniell. All rights reserved.
//

import Foundation
import CoreData


extension Question {

    @nonobjc public override class func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest(entityName: "Question");
    }

    @NSManaged public var questionContent: String?
    @NSManaged public var answerContent: String?
    @NSManaged public var examDate: NSDate?
    @NSManaged public var correctNeeded: Int16
    @NSManaged public var subject: Subject?

}
