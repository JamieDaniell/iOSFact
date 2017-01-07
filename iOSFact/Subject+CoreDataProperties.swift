//
//  Subject+CoreDataProperties.swift
//  iOSFact
//
//  Created by James Daniell on 06/01/2017.
//  Copyright © 2017 JamesDaniell. All rights reserved.
//

import Foundation
import CoreData


extension Subject {

    @nonobjc public override class func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest(entityName: "Subject");
    }

    @NSManaged public var name: String?
    @NSManaged public var icon: String?
    @NSManaged public var questions: NSSet?

}

// MARK: Generated accessors for questions
extension Subject {

    @objc(addQuestionsObject:)
    @NSManaged public func addToQuestions(_ value: Question)

    @objc(removeQuestionsObject:)
    @NSManaged public func removeFromQuestions(_ value: Question)

    @objc(addQuestions:)
    @NSManaged public func addToQuestions(_ values: NSSet)

    @objc(removeQuestions:)
    @NSManaged public func removeFromQuestions(_ values: NSSet)

}
