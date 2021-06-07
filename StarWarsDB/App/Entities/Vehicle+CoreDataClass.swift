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
public class Vehicle: AbstarctVehicle {

    static func make(from json: JSON, in context: NSManagedObjectContext) -> Vehicle? {
        guard let objectId = json["url"].url?.lastPathComponent.asInt16 else { return nil }
        let object = Vehicle(context: context)
        
        object.created = Date.fromISO8601(json["created"].stringValue) as Date?
        object.edited = Date.fromISO8601(json["edited"].stringValue) as Date?
        object.filmIds = json["films"].array?.compactMap { $0.url?.lastPathComponent.asInt }
        object.name = json["name"].string
        object.id = objectId
        
        object.cargoCapacity = Int64(json["cargo_capacity"].string ?? "-1") ?? -1
        object.consumables = json["consumables"].string
        object.costInCredits = Int64(json["cost_in_credits"].string ?? "-1") ?? -1
        object.crew = Int64(json["crew"].string ?? "-1") ?? -1
        object.length = json["length"].float ?? -1.0
        object.manufacturer = json["manufacturer"].string
        object.maxAtmospheringSpeed = Int64(json["max_atmosphering_speed"].string ?? "-1") ?? -1
        object.model = json["model"].string
        object.passengers = Int64(json["passengers"].string ?? "-1") ?? -1
        object.pilotIds = json["pilots"].array?.compactMap { $0.url?.lastPathComponent.asInt }
        object.vehicleClass = json["vehicle_class"].string
        
        debugPrint("Object created: \(type(of: self)) \(objectId)")
        
        return object
    }
    
}
