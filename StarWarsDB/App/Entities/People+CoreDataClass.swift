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
    
    static func makeOrUpdate(from json: JSON, in context: NSManagedObjectContext) -> People? {
        guard let objectId = json["url"].url?.lastPathComponent.asInt16 else { return nil }
        var itsNew = true
        let object = getUniqueInstance(from: objectId, in: context, new: &itsNew)
        
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
        
        object.updateRelationships()
        
        if itsNew == false {
            debugPrint("Object updated: \(type(of: self)) \(objectId)")
        }
        
        return object
    }
    
    func updateRelationships() {
        updateVehicleRelationship()
        updateStarshipRelationship()
        updateSpeciesRelationship()
        updatePlanetRelationship()
    }
    
    private func updatePlanetRelationship() {
        typealias Entity = Planet
        
        guard homeworld == nil else { return }
        let request: NSFetchRequest<Entity> = Entity.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "id = %i", homeworldId),
            NSPredicate(format: "SUBQUERY(residents, $x, $x.id = %i).@count = 0", id)
        ])
        
        do {
            guard let item = try request.execute().first else { return }
            homeworld = item
            item.addToResidents(self)
            let msg =
                "Make relationship " +
                "\(type(of: self)) (\(name ?? ""))" +
                " <=> " +
                "\(type(of: item)) (\(item.name ?? ""))"
            debugPrint(msg)
        } catch {
            debugPrint("Could not make relationship \(type(of: self)) <=> \(Entity.self)")
        }
    }
    
    private func updateVehicleRelationship() {
        typealias Entity = Vehicle
        
        let request: NSFetchRequest<Entity> = Entity.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "id IN %@", vehicleIds ?? []),
            NSPredicate(format: "NOT (self IN %@)", vehicles ?? []),
            NSPredicate(format: "SUBQUERY(pilots, $x, $x.id = %i).@count = 0", id)
        ])
        
        do {
            let result = try request.execute()
            if !result.isEmpty {
                result
                    .filter { $0.pilotIds?.contains(id.toInt) == true }
                    .forEach { item in
                        addToVehicles(item)
                        item.addToPilots(self)
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
    
    private func updateStarshipRelationship() {
        typealias Entity = Starship
        
        let request: NSFetchRequest<Entity> = Entity.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "id IN %@", starshipIds ?? []),
            NSPredicate(format: "NOT (self IN %@)", starships ?? []),
            NSPredicate(format: "SUBQUERY(pilots, $x, $x.id = %i).@count = 0", id)
        ])
        
        do {
            let result = try request.execute()
            if !result.isEmpty {
                result
                    .filter { $0.pilotIds?.contains(id.toInt) == true }
                    .forEach { item in
                        addToStarships(item)
                        item.addToPilots(self)
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
        
        do {
            let results = try request.execute()
            if !results.isEmpty {
                results
                    .filter { item in
                        let shouldBinded = item.peopleIds?.contains(id.toInt) == true
                        let notBinded = (item.peoples as? Set<Self>)?.first { $0.id == id } == nil
                        return shouldBinded && notBinded
                    }
                    .forEach { item in
                        item.addToPeoples(self)
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
