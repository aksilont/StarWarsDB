//
//  CoreDataStack.swift
//  StarWarsDB
//
//  Created by Aksilont on 04.06.2021.
//

import CoreData

final class CoreDataStack {
    
    private let storeIsReady = DispatchGroup()
    
    private let modelName: String
    private let storeName: String
    let migrator: CoreDataMigratorProtocol
    
    // MARK: - Singleton
    
    static var shared: CoreDataStack = CoreDataStack()
    
    // MARK: - Core Data Stack
    
    private lazy var documentsUrl: URL = {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
        else { fatalError("Unable to resolve document directory") }
        return url
    }()
    
    private lazy var objectModel: NSManagedObjectModel = {
        guard let objectModelUrl = Bundle.main.url(forResource: modelName, withExtension: "momd")
        else { fatalError("Error loading model from bundle") }
        
        guard let model = NSManagedObjectModel(contentsOf: objectModelUrl)
        else { fatalError("Error initializing momd from: \(modelName)") }
        
        return model
    }()
    
    private lazy var coordinator: NSPersistentStoreCoordinator = {
        NSPersistentStoreCoordinator(managedObjectModel: objectModel)
    }()
    
    lazy var mainContext: NSManagedObjectContext = {
        storeIsReady.wait()
        
        return DispatchQueue.anywayOnMain {
            let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            context.persistentStoreCoordinator = coordinator
            return context
        }
    }()
    
    // MARK: - Init
    
    init(modelName: String = "StarWarsDB",
         storeName: String = "StarWarsDB.sqlite",
         migrator: CoreDataMigratorProtocol = CoreDataMigrator()) {
        self.modelName = modelName
        self.storeName = storeName
        self.migrator = migrator
        registerStore()
    }
    
    func makePrivateContext() -> NSManagedObjectContext {
        storeIsReady.wait()
        
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = mainContext
        return context
    }
    
    func saveToStore() {
        storeIsReady.wait()
        
        DispatchQueue.anywayOnMain {
            guard mainContext.hasChanges else {
                debugPrint("Data has not changes")
                return
            }
            do {
                try mainContext.save()
                debugPrint("Data succesfully saved to store")
            } catch {
                debugPrint("Data not saved to store with error \(error)")
            }
        }
    }
    
    private func migrateStoreIfNeeded(at storeURL: URL, completion: @escaping() -> Void) {
        if migrator.requiresMigration(at: storeURL, toVersion: CoreDataMigrationVersion.current) {
            migrator.migrateStore(at: storeURL, toVersion: CoreDataMigrationVersion.current)
            completion()
        } else {
            completion()
        }
    }
    
    private func registerStore() {
        storeIsReady.enter()
        
        DispatchQueue.global(qos: .background).async {
            let storeUrl = self.documentsUrl.appendingPathComponent(self.storeName)
            self.migrateStoreIfNeeded(at: storeUrl) {
                do {
                    try self.coordinator.addPersistentStore(
                        ofType: NSSQLiteStoreType,
                        configurationName: nil,
                        at: storeUrl,
                        options: nil
                    )
                    self.storeIsReady.leave()
                } catch {
                    fatalError("Error create store: \(error)")
                }
            }
        }
    }
    
}
