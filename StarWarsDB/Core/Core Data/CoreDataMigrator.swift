//
//  CoreDataMigrator.swift
//  StarWarsDB
//
//  Created by Aksilont on 29.06.2021.
//

import CoreData

protocol CoreDataMigratorProtocol {
    func requiresMigration(at storeURL: URL, toVersion version: CoreDataMigrationVersion) -> Bool
    func migrateStore(at storeURL: URL, toVersion version: CoreDataMigrationVersion)
}

class CoreDataMigrator: CoreDataMigratorProtocol {
    
    // MARK: - Check
    
    func requiresMigration(at storeURL: URL, toVersion version: CoreDataMigrationVersion) -> Bool {
        guard let metadata = NSPersistentStoreCoordinator.metadata(at: storeURL)
        else { return false }
        return (CoreDataMigrationVersion.compatibleVersionForStoreMetadata(metadata) != version)
    }
    
    // MARK: - WAL (Write-Ahead Logging)
    
    /*
    Начиная с iOS 7, Core Data использует опцию Write-Ahead Logging (WAL) в хранилищах SQLite,
    чтобы обеспечить возможность восстановления после сбоев, позволяя откатить изменения до тех пор,
    пока база данных не станет стабильной
    Вместо того, чтобы напрямую записывать изменения в sqlite файл и иметь предварительную копию изменений для отката,
    в режиме WAL изменения сначала записываются в sqlite-wal файл,
    а в какой-то момент в будущем эти изменения переносятся в sqlite файл
    По сути файл sqlite-wal представляет собой обновленную копию некоторых данных, хранящихся в основном sqlite файле
    
    sqlite-wal и sqlite файлы хранят свои данные, используя одну и туже структуру,
    чтобы легко передавать данные между ними
    Однако эта общая структура вызывает проблемы во время миграции, поскольку Core Data переносит только данные,
    хранящиеся в sqlite файле в новую структуру, оставляя данные в sqlite-wal файле в старой структуре
    В результате, несоответствие в структуре приведет к сбою, когда Core Data попытается обновить/использовать данные,
    хранящиеся в sqlite-wal файле
    Чтобы избежать этого сбоя, нужно принудительно перенести любые данные из sqlite-wal файла в sqlite файл перед
    выполнением миграции - процесс, известный как checkpointing
    */
    
    func forceWALCheckpointForStore(at storeURL: URL) {
        guard let metadata = NSPersistentStoreCoordinator.metadata(at: storeURL),
              let currentModel = NSManagedObjectModel.compatibleModelForStoreMetadata(metadata)
        else { return }
        
        do {
            let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: currentModel)
            
            let options = [NSSQLitePragmasOption: ["journal_mode": "DELETE"]]
            let store = persistentStoreCoordinator.addPersistentStore(at: storeURL, options: options)
            try persistentStoreCoordinator.remove(store)
        } catch {
            fatalError("Failed to force WAL checkpointing, error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Migration steps
    
    // Перед выполнением миграции необходимо определить очередность (шагов) процесса миграции
    
    private func migrationsStepsForStore(
        at storeURL: URL,
        toVersion destinationVersion: CoreDataMigrationVersion
    ) -> [CoreDataMigrationStep] {
        guard let metadata = NSPersistentStoreCoordinator.metadata(at: storeURL),
              let sourceVersion = CoreDataMigrationVersion.compatibleVersionForStoreMetadata(metadata)
        else { fatalError("Unknown store version at URL \(storeURL)") }
        
        return migrationSteps(fromsSourceVersion: sourceVersion, toDestinatinVersion: destinationVersion)
    }
    
    private func migrationSteps(
        fromsSourceVersion sourceVersion: CoreDataMigrationVersion,
        toDestinatinVersion destinationVersion: CoreDataMigrationVersion
    ) -> [CoreDataMigrationStep] {
        var sourceVersion = sourceVersion
        var migrationSteps = [CoreDataMigrationStep]()
        
        while sourceVersion != destinationVersion, let nextVersion = sourceVersion.nextVersion() {
            let step = CoreDataMigrationStep(sourceVersion: sourceVersion, destinationVersion: nextVersion)
            migrationSteps.append(step)
            
            sourceVersion = nextVersion
        }
        
        return migrationSteps
    }
    
    // MARK: - Migration
    
    func migrateStore(at storeURL: URL, toVersion version: CoreDataMigrationVersion) {
        forceWALCheckpointForStore(at: storeURL)
        
        var currentURL = storeURL
        let migrationSteps = migrationsStepsForStore(at: storeURL, toVersion: version)
        
        for step in migrationSteps {
            let manager = NSMigrationManager(sourceModel: step.sourceModel, destinationModel: step.destinationModel)
//            let destinationURL = URL(fileURLWithPath: NSTemporaryDirectory(),
//                                     isDirectory: true).appendingPathComponent(UUID().uuidString)
            let destinationURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
            
            do {
                try manager.migrateStore(
                    from: currentURL,
                    sourceType: NSSQLiteStoreType,
                    options: nil,
                    with: step.mappingModel,
                    toDestinationURL: destinationURL,
                    destinationType: NSSQLiteStoreType,
                    destinationOptions: nil)
            } catch {
                fatalError(
                    """
                    Failed attemptimg to migrate from \(step.sourceModel) to \(step.destinationModel)
                    Error: \(error.localizedDescription)
                    """
                )
            }
            
            if currentURL != storeURL {
                NSPersistentStoreCoordinator.destroyStore(at: currentURL)
            }
            
            currentURL = destinationURL
        }
        
        NSPersistentStoreCoordinator.replaceStore(at: storeURL, withStoreAt: currentURL)
        
        if (currentURL != storeURL) {
            NSPersistentStoreCoordinator.destroyStore(at: currentURL)
        }
    }
    
}
