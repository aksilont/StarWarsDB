//
//  People+CoreDataClass.swift
//  StarWarsDB
//
//  Created by Aksilont on 04.06.2021.
//
//

import Foundation
import CoreData
import SwiftyJSON

@objc(People)
public class People: NSManagedObject {

    static func make(from json: JSON, in context: NSManagedObjectContext) -> People? {
        guard let objectId = json["url"].url?.lastPathComponent.asInt16 else { return nil }
        let object = People(entity: entity(), insertInto: context)
        
        object.created = Date.fromISO8601(json["created"].stringValue) as Date?
        object.edited = Date.fromISO8601(json["edited"].stringValue) as Date?
        object.filmIds = json["films"].array?.compactMap { $0.url?.lastPathComponent.asInt }
        object.name = json["name"].string
        object.id = objectId
        
        object.birthYear = json["birth_year"].string
        object.eyeColor = json["eye_color"].string
        object.gender = json["gender"].string
        object.hairColor = json["hair_color"].string
        object.height = json["height"].string?.asInt16 ?? -1
        object.homeworldId = json["homeworld"].url?.lastPathComponent.asInt16 ?? -1
        object.mass = json["mass"].string?.asInt16 ?? -1
        object.skinColor = json["skin_color"].string
        object.speciesIds = json["species"].array?.compactMap { $0.url?.lastPathComponent.asInt }
        object.starshipIds = json["starships"].array?.compactMap { $0.url?.lastPathComponent.asInt }
        object.vehicleIds = json["vehicles"].array?.compactMap { $0.url?.lastPathComponent.asInt }
        
        debugPrint("Object created: \(type(of: self)) \(objectId)")
        
        return object
    }
    
}
