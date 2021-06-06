//
//  Starship+CoreDataProperties.swift
//  StarWarsDB
//
//  Created by Aksilont on 06.06.2021.
//
//

import Foundation
import CoreData

extension Starship {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Starship> {
        return NSFetchRequest<Starship>(entityName: "Starship")
    }

    @NSManaged public var hyperdriveRating: Float
    @NSManaged public var mglt: Int16
    @NSManaged public var starshipClass: String?
    @NSManaged public var pilots: NSSet?

}

// MARK: Generated accessors for pilots
extension Starship {

    @objc(addPilotsObject:)
    @NSManaged public func addToPilots(_ value: People)

    @objc(removePilotsObject:)
    @NSManaged public func removeFromPilots(_ value: People)

    @objc(addPilots:)
    @NSManaged public func addToPilots(_ values: NSSet)

    @objc(removePilots:)
    @NSManaged public func removeFromPilots(_ values: NSSet)

}
