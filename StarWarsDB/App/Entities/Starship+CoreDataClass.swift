//
//  Starship+CoreDataClass.swift
//  StarWarsDB
//
//  Created by Aksilont on 04.06.2021.
//
//

import Foundation
import CoreData
import SwiftyJSON

@objc(Starship)
public class Starship: AbstarctVehicle {

    static func make(from json: JSON, in context: NSManagedObjectContext) -> Starship? {
        guard let objectId = json["url"].url?.lastPathComponent.asInt16 else { return nil }
        let object = Starship(context: context)
        
        object.created = Date.fromISO8601(json["created"].stringValue) as Date?
        object.edited = Date.fromISO8601(json["edited"].stringValue) as Date?
        object.filmIds = json["films"].array?.compactMap { $0.url?.lastPathComponent.asInt }
        object.name = json["name"].string
        object.id = objectId
        
        object.cargoCapacity = Int64(json["cargo_capacity"].string ?? "-1") ?? -1
        object.consumables = json["consumables"].string
        object.costInCredits = Int64(json["cost_in_credits"].string ?? "-1") ?? -1
        object.crew = Int64(json["crew"].string ?? "-1") ?? -1
        object.length = Float(json["length"].string ?? "-1") ?? -1.0
        object.manufacturer = json["manufacturer"].string
        object.maxAtmospheringSpeed = Int64(json["max_atmosphering_speed"].string ?? "-1") ?? -1
        object.model = json["model"].string
        object.passengers = Int64(json["passengers"].string ?? "-1") ?? -1
        object.pilotIds = json["pilots"].array?.compactMap { $0.url?.lastPathComponent.asInt }
        object.starshipClass = json["starship_class"].string
        object.mglt = json["MGLT"].string?.asInt16 ?? -1
        object.hyperdriveRating = Float(json["hyperdrive_rating"].string ?? "-1") ?? -1.0

        debugPrint("Object created: \(type(of: self)) \(objectId)")
        
        return object
    }
    
}
