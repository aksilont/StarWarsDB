//
//  CoreDataManager.swift
//  StarWarsDB
//
//  Created by Aksilont on 30.06.2021.
//

import CoreData

final class CoreDataManager {
    
    let migrator: CoreDataMigratorProtocol
    private let storeType: String
    
    // MARK: - Singleton
    
    static let shared: CoreDataManager = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
       let container = NSPersistentContainer(name: "StarWarsDB")
        return container
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
            
        }
    }
    
    private func migrateStoreIfNeeded(completion: @escaping() -> Void) {
        
    }
    
}
