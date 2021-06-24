//
//  Vehicle+CoreDataClass.swift
//  StarWarsDB
//
//  Created by Aksilont on 04.06.2021.
//
//

import Foundation
import CoreData
import SwiftyJSON

@objc(Vehicle)
public final class Vehicle: AbstarctVehicle, ObjectResultable {

    static var modelType: ModelType = .vehicles
    
    static func makeOrUpdate(from json: JSON, in context: NSManagedObjectContext) -> Vehicle? {
        guard let objectId = json["url"].url?.lastPathComponent.asInt16 else { return nil }
        var itsNew = true
        let object = getUniqueInstance(from: objectId, in: context, new: &itsNew)
        
        object.created = Date.fromISO8601(json["created"].stringValue) as Date?
        object.edited = Date.fromISO8601(json["edited"].stringValue) as Date?
        object.filmIds = json["films"].array?.compactMap { $0.url?.lastPathComponent.asInt }
        object.name = json["name"].string
        object.id = objectId
        
        object.cargoCapacity = Int64(json["cargo_capacity"].string ?? "-1") ?? -1
        object.consumables = json["consumables"].string
        object.cost = Int64(json["cost_in_credits"].string ?? "-1") ?? -1
        object.crew = Int64(json["crew"].string ?? "-1") ?? -1
        object.length = Float(json["length"].string ?? "-1") ?? -1.0
        object.manufacturer = json["manufacturer"].string
        object.maxAtmospheringSpeed = Int64(json["max_atmosphering_speed"].string ?? "-1") ?? -1
        object.model = json["model"].string
        object.passengers = Int64(json["passengers"].string ?? "-1") ?? -1
        object.pilotIds = json["pilots"].array?.compactMap { $0.url?.lastPathComponent.asInt }
        object.vehicleClass = json["vehicle_class"].string
        
        object.updateRelationships()
        
        if itsNew == false {
            debugPrint("Object updated: \(type(of: self)) \(objectId)")
        }
        
        return object
    }
    
    func updateRelationships() {
        updatePeopleRelationship()
    }
    
    private func updatePeopleRelationship() {
        typealias Entity = People
        
        let request: NSFetchRequest<Entity> = Entity.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "id IN %@", pilotIds ?? []),
            NSPredicate(format: "NOT (self IN %@)", pilots ?? []),
            NSPredicate(format: "SUBQUERY(vehicles, $x, $x.id = %i).@count = 0", id)
        ])
        
        do {
            let result = try request.execute()
            if !result.isEmpty {
                result
                    .filter { $0.vehicleIds?.contains(id.toInt) == true }
                    .forEach { item in
                        addToPilots(item)
                        item.addToVehicles(self)
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
