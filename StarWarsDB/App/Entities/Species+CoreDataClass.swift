//
//  Species+CoreDataClass.swift
//  StarWarsDB
//
//  Created by Aksilont on 06.06.2021.
//
//

import Foundation
import CoreData
import SwiftyJSON

@objc(Species)
public class Species: NSManagedObject {

    static func make(from json: JSON, in context: NSManagedObjectContext) -> Species? {
        guard let objectId = json["url"].url?.lastPathComponent.asInt16 else { return nil }
        let object = Species(entity: entity(), insertInto: context)
        
        object.created = Date.fromISO8601(json["created"].stringValue) as Date?
        object.edited = Date.fromISO8601(json["edited"].stringValue) as Date?
        object.filmIds = json["films"].array?.compactMap { $0.url?.lastPathComponent.asInt }
        object.name = json["name"].string
        object.id = objectId
        
        object.averageHeight = Float(json["average_height"].string ?? "-1.0") ?? -1.0
        object.averageLifespan = json["average_lifespan"].string?.asInt16 ?? -1
        object.classification = json["classification"].string
        object.designation = json["designation"].string
        object.language = json["language"].string
        object.homeworldId = json["homeworld"].url?.lastPathComponent.asInt16 ?? -1
        object.peopleIds = json["people"].array?.compactMap { $0.url?.lastPathComponent.asInt }
        
        object.eyeColors = json["eye_colors"].string?.components(separatedBy: ", ")
        object.heirColors = json["hair_colors"].string?.components(separatedBy: ", ")
        object.skinColors = json["skin_colors"].string?.components(separatedBy: ", ")
        
        debugPrint("Object created: \(type(of: self)) \(objectId)")
        
        return object
    }
    
}
