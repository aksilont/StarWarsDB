//
//  SpeciesMigrationPolicy.swift
//  StarWarsDB
//
//  Created by Aksilont on 26.06.2021.
//

import CoreData

typealias MigrationPolicyData = (
    sourceVersion: String,
    sourceKeys: [String],
    sourceValues: [String: Any],
    desctinationInstance: NSManagedObject,
    destinationKeys: [String]
)

@objc(SpeciesMigrationPolicy)
final class SpeciesMigrationPolicy: NSEntityMigrationPolicy {
    
    override func createDestinationInstances(forSource sInstance: NSManagedObject,
                                             in mapping: NSEntityMapping,
                                             manager: NSMigrationManager) throws {
        guard let data = getMigrationData(forSource: sInstance, in: mapping, manager: manager)
        else { return try super.createDestinationInstances(forSource: sInstance, in: mapping, manager: manager) }
        
        switch data.sourceVersion {
        case "2":
            migratePropertiesFrom2To3(with: data)
        default:
            break
        }
        
        manager.associate(sourceInstance: sInstance, withDestinationInstance: data.desctinationInstance, for: mapping)
    }
    
    private func getMigrationData(forSource sInstance: NSManagedObject,
                                  in mapping: NSEntityMapping,
                                  manager: NSMigrationManager) -> MigrationPolicyData? {
        guard let sourceVersion = mapping.userInfo?["sourceVersion"] as? String else { return nil }
        
        let sourceKeys = Array(sInstance.entity.attributesByName.keys)
        let sourceValues = sInstance.dictionaryWithValues(forKeys: sourceKeys)
        
        guard let destinationEntityName = mapping.destinationEntityName else { return nil }
        let destinationInstance = NSEntityDescription.insertNewObject(
            forEntityName: destinationEntityName,
            into: manager.destinationContext)
        let destinationKeys = Array(destinationInstance.entity.attributesByName.keys)
        
        return (sourceVersion, sourceKeys, sourceValues, destinationInstance, destinationKeys)
    }
    
    private func migratePropertiesFrom2To3(with data: MigrationPolicyData) {
        for key in data.destinationKeys {
            if let value = data.sourceValues[key] {
                if key == "eyeColors", let eyeColors = value as? [String] {
                    data.desctinationInstance.setValue(eyeColors.joined(separator: ", "), forKey: "eyeColors")
                } else {
                    data.desctinationInstance.setValue(value, forKey: key)
                }
            }
        }
    }
    
}
