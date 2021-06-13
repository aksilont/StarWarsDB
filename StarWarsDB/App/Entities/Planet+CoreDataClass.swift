//
//  Planet+CoreDataClass.swift
//  StarWarsDB
//
//  Created by Aksilont on 06.06.2021.
//
//

import Foundation
import CoreData
import SwiftyJSON

@objc(Planet)
public class Planet: NSManagedObject {

    static func makeOrUpdate(from json: JSON, in context: NSManagedObjectContext) -> Planet? {
        guard let objectId = json["url"].url?.lastPathComponent.asInt16 else { return nil }
        var itsNew = true
        let object = getUniqueInstance(from: objectId, in: context, new: &itsNew)
        
        object.created = Date.fromISO8601(json["created"].stringValue) as Date?
        object.edited = Date.fromISO8601(json["edited"].stringValue) as Date?
        object.filmIds = json["films"].array?.compactMap { $0.url?.lastPathComponent.asInt }
        object.name = json["name"].string
        object.id = objectId
        
        object.climate = json["climate"].string
        object.diameter = Int32(json["diameter"].string ?? "-1") ?? -1
        object.gravity = json["gravity"].string
        object.orbitalPeriod = json["orbital_period"].string?.asInt16 ?? -1
        object.popultaion = Int64(json["popultaion"].string ?? "-1") ?? -1
        object.rotationPeriod = json["rotation_period"].string?.asInt16 ?? -1
        object.surfaceWater = json["surface_water"].string?.asInt16 ?? -1
        object.terrain = json["terrain"].string
        object.residentIds = json["residents"].array?.compactMap { $0.url?.lastPathComponent.asInt }
        
        object.updateRelationships()
        
        if itsNew == false {
            debugPrint("Object updated: \(type(of: self)) \(objectId)")
        }
        
        return object
    }
    
    func updateRelationships() {
        updatePeopleRelationship()
        updateSpeciesRelationship()
    }
    
    private func updatePeopleRelationship() {
        typealias Entity = People
        
        let request: NSFetchRequest<Entity> = Entity.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "id IN %@", residentIds ?? []),
            NSPredicate(format: "NOT (self IN %@)", residents ?? []),
            NSPredicate(format: "homeworldId = %i", id)
        ])
        
        do {
            let result = try request.execute()
            if !result.isEmpty {
                result
                    .forEach { item in
                        addToResidents(item)
                        item.homeworld = self
                        let msg =
                            "Make relationship " +
                            "\(type(of: self)) (\(name ?? ""))" +
                            " <=> " +
                            "\(type(of: item)) (\(item.name ?? ""))"
                        debugPrint(msg)
                    }
            }
        } catch {
            debugPrint("Could not make relationship \(type(of: self)) <=> \(Entity.self)")
        }
    }
    
    private func updateSpeciesRelationship() {
        typealias Entity = Species
        
        let request: NSFetchRequest<Entity> = Entity.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "homeworldId = %i", id)
        ])
        
        do {
            let results = try request.execute()
            if !results.isEmpty {
                results
                    .filter { $0.homeworld == nil }
                    .forEach { item in
                        item.homeworld = self
                        let msg =
                            "Make relationship " +
                            "\(type(of: self)) (\(name ?? ""))" +
                            " <=> " +
                            "\(type(of: item)) (\(item.name ?? ""))"
                        debugPrint(msg)
                    }
            }
        } catch {
            debugPrint("Could not make relationship \(type(of: self)) <=> \(Entity.self)")
        }
    }
    
}
