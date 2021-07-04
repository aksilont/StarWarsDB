//
//  CoreDataManager.swift
//  StarWarsDB
//
//  Created by Aksilont on 30.06.2021.
//

import CoreData

// Алтернативный вариант создания CoreDataStack с ипользование Persistent Container

final class CoreDataManager {
    
    let migrator: CoreDataMigratorProtocol
    private let storeType: String
    
    // MARK: - Singleton
    
    static let shared: CoreDataManager = CoreDataManager()
    
    // MARK: - CoreData Stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "StarWarsDB")
        let description = container.persistentStoreDescriptions.first
        description?.shouldInferMappingModelAutomatically = false
        description?.shouldMigrateStoreAutomatically = false
        description?.type = storeType
        return container
    }()
    
    lazy var mainContext: NSManagedObjectContext = {
        let context = persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        return context
    }()
    
    lazy var backgroundContext: NSManagedObjectContext = {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }()
    
    // MARK: - Init
    
    init(storeType: String = NSSQLiteStoreType, migrator: CoreDataMigratorProtocol = CoreDataMigrator()) {
        self.storeType = storeType
        self.migrator = migrator
    }
    
    // MARK: - Setup
    
    func setup(completion: @escaping() -> Void) {
        loadPersistentStore {
            completion()
        }
    }
    
    // MARK: - Loading
    
    private func loadPersistentStore(completion: @escaping() -> Void) {
        migrateStoreIfNeeded {
            self.persistentContainer.loadPersistentStores { _, error in
                guard error == nil else { fatalError("Was unable to load store \(error!.localizedDescription)") }
                completion()
            }
        }
    }
    
    private func migrateStoreIfNeeded(completion: @escaping() -> Void) {
        guard let storeUrl = persistentContainer.persistentStoreDescriptions.first?.url else {
            fatalError("persistentContrainer was not setup properly")
        }
        
        if migrator.requiresMigration(at: storeUrl, toVersion: CoreDataMigrationVersion.current) {
            DispatchQueue.global(qos: .userInitiated).async {
                self.migrator.migrateStore(at: storeUrl, toVersion: CoreDataMigrationVersion.current)
                DispatchQueue.main.async {
                    completion()
                }
            }
        } else {
            completion()
        }
    }
    
    // MARK: - Save to store
    
    func saveToStore() {
        guard mainContext.hasChanges else {
            debugPrint("Data has not changes")
            return
        }
        
        do {
            try mainContext.save()
            debugPrint("Data succesfully saved to store")
        } catch {
            debugPrint("Data not saved to store with error \(error.localizedDescription)")
        }
    }
    
}
