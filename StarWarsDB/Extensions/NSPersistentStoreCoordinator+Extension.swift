//
//  NSPersistentStoreCoordinator+Extension.swift
//  StarWarsDB
//
//  Created by Aksilont on 29.06.2021.
//

import CoreData

extension NSPersistentStoreCoordinator {
    
    // MARK: - Destory
    
    static func destroyStore(at storeURL: URL) {
        do {
            let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: NSManagedObjectModel())
            try persistentStoreCoordinator.destroyPersistentStore(at: storeURL,
                                                                  ofType: NSSQLiteStoreType,
                                                                  options: nil)
        } catch {
            fatalError("Failed to destroy persistent store at \(storeURL), error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Replace
    
    static func replaceStore(at targetURL: URL, withStoreAt sourceURL: URL) {
        do {
            let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: NSManagedObjectModel())
            try persistentStoreCoordinator.replacePersistentStore(
                at: targetURL,
                destinationOptions: nil,
                withPersistentStoreFrom: sourceURL,
                sourceOptions: nil,
                ofType: NSSQLiteStoreType
            )
        } catch {
            fatalError(
                """
                Failed to replace persistent store at \(targetURL) with \(sourceURL),
                error: \(error.localizedDescription)
                """
            )
        }
    }
    
    // MARK: - Meta
    
    static func metadata(at storeURL: URL) -> [String: Any]? {
        return try? NSPersistentStoreCoordinator.metadataForPersistentStore(
            ofType: NSSQLiteStoreType,
            at: storeURL,
            options: nil
        )
    }
    
    // MARK: - Add
    
    func addPersistentStore(at storeURL: URL, options: [AnyHashable: Any]) -> NSPersistentStore {
        do {
            return try addPersistentStore(ofType: NSSQLiteStoreType,
                                          configurationName: nil,
                                          at: storeURL,
                                          options: options)
        } catch {
            fatalError("Failed to add persistent store to coordinator, error: \(error.localizedDescription)")
        }
    }
    
}
