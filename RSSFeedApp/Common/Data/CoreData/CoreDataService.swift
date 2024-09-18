//
//  CoreDataService.swift
//  RSSFeedApp
//
//  Created by Jurica Bozikovic on 17.09.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//

import UIKit
import CoreData

//  MARK: - CoreDataServiceConstants
struct CoreDataServiceConstants {
    static let modelName: String = "RSSFeedApp"
    static let entityChannel: String = "RSSChannel"
    static let entityItem: String = "RSSItem"
}

//  MARK: - CoreDataProtocol
protocol CoreDataProtocol {
    var persistentContainer: NSPersistentContainer { get }
    var managedContext: NSManagedObjectContext { get }
    func saveContextIfNeeded ()
    func saveContext() -> Bool
    func deleteItem<T>(_ item: T) -> Bool where T: NSManagedObject
    func createEntity<T>(with entityName: String) -> T? where T: NSManagedObject
    func fetchItems<T>(with entityName: String, sortDescriptor: [NSSortDescriptor]) -> [T]? where T: NSManagedObject
}

//  MARK: - CoreDataService
class CoreDataService: CoreDataProtocol {
    lazy var persistentContainer: NSPersistentContainer = {
        //  The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        let container = NSPersistentContainer(name: CoreDataServiceConstants.modelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            /*
             Typical reasons for an error here include:
             * The parent directory does not exist, cannot be created, or disallows writing.
             * The persistent store is not accessible, due to permissions or data protection when the device is locked.
             * The device is out of space.
             * The store could not be migrated to the current model version.
             Check the error message to determine what the actual problem was.
             */
            guard let error = error as NSError? else { return }
            Utility.printIfDebug(string: "CoreData loadPersistentStores Error: \(error), \(error.userInfo)")
        })
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    var managedContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Core Data Saving support
    func saveContextIfNeeded () {
        guard managedContext.hasChanges else { return }
        _ = saveContext()
    }
    
    func saveContext() -> Bool {
        do {
            try managedContext.save()
            return true
        } catch let error as NSError {
            Utility.printIfDebug(string: "CoreData saveContextIfNeeded Error: \(error), \(error.userInfo)")
            return false
        }
    }
}

//  MARK: - Create and fetch entities
extension CoreDataService {
    func deleteItem<T>(_ item: T) -> Bool where T: NSManagedObject {
        managedContext.delete(item)
        return saveContext()
    }
    
    func createEntity<T>(with entityName: String) -> T? where T: NSManagedObject {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: entityName, in: self.managedContext) else {
            return nil
        }
        return NSManagedObject(entity: entityDescription, insertInto: self.managedContext) as? T
    }

    func fetchItems<T>(with entityName: String, sortDescriptor: [NSSortDescriptor] = []) -> [T]? where T: NSManagedObject {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.sortDescriptors = sortDescriptor
        do {
            return try managedContext.fetch(fetchRequest) as? [T]
        } catch let error as NSError {
            Utility.printIfDebug(string: "Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
}
