//
//  CoreData.swift
//  iOSFact
//
//  Created by James Daniell on 03/01/2017.
//  Copyright © 2017 JamesDaniell. All rights reserved.
//


import Foundation
import CoreData

class CoreData
{
    let model = "iOSFactModel"
    private lazy var applicationDocumentsDirectory: NSURL =
    {
        let urls = FileManager.default.urls(for: .documentDirectory  , in: .userDomainMask)
        return urls[urls.count - 1] as NSURL
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: self.model , withExtension: "momd" )
        return NSManagedObjectModel(contentsOf: modelURL!)!
    }()
    
    lazy var persistenceStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent(self.model)
        do
        {
            let options = [NSMigratePersistentStoresAutomaticallyOption: true]
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil , at: url , options: options)
        }
        catch
        {
            fatalError("Error adding persistence store")
        }
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        var context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistenceStoreCoordinator
        return context
    }()
    
    func saveContext()
    {
        if managedObjectContext.hasChanges
        {
            do
            {
                try managedObjectContext.save()
            }
            catch
            {
                print("Error saving Context")
                abort()
            }
        }
    }
}
