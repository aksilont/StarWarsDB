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

    static func makeOrUpdate(from json: JSON, in context: NSManagedObjectContext) -> Species? {
        guard let objectId = json["url"].url?.lastPathComponent.asInt16 else { return nil }
        let object = getUniqueInstance(from: objectId, in: context)
        
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
        
        debugPrint("Object overwritten: \(type(of: self)) \(objectId)")
        
        object.updateRelationships()
        
        return object
    }
    
    func updateRelationships() {
        updateHomeworldRelationships()
        updatePeopleRelationship()
    }
    
    private func updateHomeworldRelationships() {
        typealias Entity = Planet
        
        guard homeworld == nil else { return }
        let request: NSFetchRequest<Entity> = Entity.fetchRequest()
        request.predicate = NSPredicate(format: "id = %i", homeworldId)
        
        do {
            guard let homeworld = try request.execute().first else { return }
            self.homeworld = homeworld
            let msg =
                "Make relationship " +
                "\(type(of: self)) (\(name ?? ""))" +
                " <=> " +
                "\(Entity.self) (\(homeworld.name ?? ""))"
            debugPrint(msg)
        } catch {
            debugPrint("Could not make relationship \(type(of: self)) <=> \(Entity.self)")
        }
    }
    
    private func updatePeopleRelationship() {
        typealias Entity = People
        
        let request: NSFetchRequest<Entity> = Entity.fetchRequest()
        
        do {
            let results = try request.execute()
            if !results.isEmpty {
                results
                    .filter { item in
                        let shouldBinded = item.speciesIds?.contains(id.toInt) == true
                        let notBinded = (item.species as? Set<Self>)?.first { $0.id == id } == nil
                        return shouldBinded && notBinded
                    }
                    .forEach { item in
                        item.addToSpecies(self)
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
