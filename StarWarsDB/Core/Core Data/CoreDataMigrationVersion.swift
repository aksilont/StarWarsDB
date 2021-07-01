//
//  CoreDataMigrationVersion.swift
//  StarWarsDB
//
//  Created by Aksilont on 29.06.2021.
//

import CoreData

enum CoreDataMigrationVersion: String, CaseIterable {
    
    case version1 = "StarWarsDB"
    case version2 = "StarWarsDB 2"
    case version3 = "StarWarsDB 3"
    
    // MARK: - Current
    
    static var current: CoreDataMigrationVersion {
        guard let current = allCases.last else {
            fatalError("No model versions found")
        }
        return current
    }
    
    // MARK: - Migration
    
    func nextVersion() -> CoreDataMigrationVersion? {
        switch self {
        case .version1:
            return .version2
        case .version2:
            return .version3
        case .version3:
            return nil
        }
    }
    
    // MARK: - Compatible
    
    static func compatibleVersionForStoreMetadata(_ metadata: [String: Any]) -> CoreDataMigrationVersion? {
        let compatibleVersion = CoreDataMigrationVersion.allCases.first {
            let model = NSManagedObjectModel.managedObjectModel(forResource: $0.rawValue)
            return model.isConfiguration(withName: nil, compatibleWithStoreMetadata: metadata)
        }
        return compatibleVersion
    }
    
}
