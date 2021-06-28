//
//  ProgressiveMigrator.swift
//  StarWarsDB
//
//  Created by Aksilont on 28.06.2021.
//

import CoreData

final class ProgressiveMigrator {
    
    private let modelName: String
    private let storeUrl: URL
    private let tempUrl: URL
    private let model: NSManagedObjectModel
    
    init(modelName: String,
         model: NSManagedObjectModel,
         storeUrl: URL,
         tempUrl: URL) {
        self.modelName = modelName
        self.model = model
        self.storeUrl = storeUrl
        self.tempUrl = tempUrl
    }
    
    private lazy var modelUrls: [URL] = {
        var urls = [URL]()
        guard let momdUrl = Bundle.main.url(forResource: modelName, withExtension: "momd") else { return [] }
        
        do {
            let contents = try FileManager.default.contentsOfDirectory(atPath: momdUrl.path)
            
            contents.forEach { path in
                let suffixArray = Array(path.utf16.suffix(4))
                
                if String(utf16CodeUnits: suffixArray, count: suffixArray.count) == ".mom" {
                    let url = URL(fileURLWithPath: path, relativeTo: momdUrl)
                    urls.append(url)
                }
            }
        } catch {
            fatalError("\(error.localizedDescription)")
        }
        
        return urls
    }()
    
    func destinationModel() -> NSManagedObjectModel? {
        guard !modelUrls.isEmpty else { return nil }
        return NSManagedObjectModel(contentsOf: modelUrls.removeFirst())
    }
    
    func mapping(from sourceModel: NSManagedObjectModel, to destinationModel: NSManagedObjectModel) -> NSMappingModel? {
        return NSMappingModel(from: [Bundle.main], forSourceModel: sourceModel, destinationModel: destinationModel)
    }
    
    func migrateIfNeeded() throws {
        guard FileManager.default.fileExists(atPath: storeUrl.path) else { return }
        try migrateRecursively()
    }
    
    private func migrateRecursively() throws {
        let metadata = try NSPersistentStoreCoordinator.metadataForPersistentStore(
            ofType: NSSQLiteStoreType,
            at: storeUrl,
            options: nil
        )
        
        let isCompatible = model.isConfiguration(withName: nil, compatibleWithStoreMetadata: metadata)
        
        guard !isCompatible,
              let sourceModel = NSManagedObjectModel.mergedModel(from: [Bundle.main], forStoreMetadata: metadata),
              let destinationModel = destinationModel()
        else { return }
        
        guard let mapping = self.mapping(from: sourceModel, to: destinationModel)
        else { return try migrateRecursively() }
        
        let migrationManager = NSMigrationManager(sourceModel: sourceModel, destinationModel: destinationModel)
        
        if FileManager.default.fileExists(atPath: tempUrl.path) {
            try FileManager.default.removeItem(at: tempUrl)
        }
        
        try migrationManager.migrateStore(
            from: storeUrl,
            sourceType: NSSQLiteStoreType,
            options: nil,
            with: mapping,
            toDestinationURL: tempUrl,
            destinationType: NSSQLiteStoreType,
            destinationOptions: nil
        )
        
        try FileManager.default.removeItem(at: storeUrl)
        try FileManager.default.moveItem(at: tempUrl, to: storeUrl)
        
        try migrateRecursively()
    }
}
