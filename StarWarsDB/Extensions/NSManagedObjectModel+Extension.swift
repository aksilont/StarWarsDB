//
//  NSManagedObjectModel+Extension.swift
//  StarWarsDB
//
//  Created by Aksilont on 29.06.2021.
//

import CoreData

extension NSManagedObjectModel {
    
    // MARK: - NSManagedObjectModel for resource
    
    static func managedObjectModel(forResource resource: String) -> NSManagedObjectModel {
        let mainBundle = Bundle.main
        let subdirectory = "StarWarsDB.momd"
        let omoURL = mainBundle.url(forResource: resource, withExtension: "omo", subdirectory: subdirectory)
        let momURL = mainBundle.url(forResource: resource, withExtension: "mom", subdirectory: subdirectory)
        
        guard let url = omoURL ?? momURL else {
            fatalError("Unable to find model in bundle")
        }
        
        guard let model = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Unable to load model in bundle")
        }
        
        return model
    }
    
    // MARK: - NSManagedObjectModel compatible metadata
    
    static func compatibleModelForStoreMetadata(_ metadata: [String: Any]) -> NSManagedObjectModel? {
        let mainBundle = Bundle.main
        return NSManagedObjectModel.mergedModel(from: [mainBundle], forStoreMetadata: metadata)
    }
    
}
