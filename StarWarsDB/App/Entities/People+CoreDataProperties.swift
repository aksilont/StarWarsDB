//
//  People+CoreDataProperties.swift
//  StarWarsDB
//
//  Created by Aksilont on 04.06.2021.
//
//

import Foundation
import CoreData

extension People {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<People> {
        return NSFetchRequest<People>(entityName: "People")
    }

    @NSManaged public var birthday: String?
    @NSManaged public var created: Date?
    @NSManaged public var edited: Date?
    @NSManaged public var eyeColor: String?
    @NSManaged public var filmIds: NSObject?
    @NSManaged public var gender: String?
    @NSManaged public var hairColor: String?
    @NSManaged public var height: Int16
    @NSManaged public var homeworldId: Int16
    @NSManaged public var id: String?
    @NSManaged public var mass: Int16
    @NSManaged public var name: String?
    @NSManaged public var skinColor: String?
    @NSManaged public var speciesIds: NSObject?
    @NSManaged public var starshipIds: NSObject?
    @NSManaged public var vehicleIds: NSObject?
    @NSManaged public var vehicles: NSSet?
    @NSManaged public var starships: NSSet?

}

// MARK: Generated accessors for vehicles
extension People {

    @objc(addVehiclesObject:)
    @NSManaged public func addToVehicles(_ value: Vehicle)

    @objc(removeVehiclesObject:)
    @NSManaged public func removeFromVehicles(_ value: Vehicle)

    @objc(addVehicles:)
    @NSManaged public func addToVehicles(_ values: NSSet)

    @objc(removeVehicles:)
    @NSManaged public func removeFromVehicles(_ values: NSSet)

}

// MARK: Generated accessors for starships
extension People {

    @objc(addStarshipsObject:)
    @NSManaged public func addToStarships(_ value: Starship)

    @objc(removeStarshipsObject:)
    @NSManaged public func removeFromStarships(_ value: Starship)

    @objc(addStarships:)
    @NSManaged public func addToStarships(_ values: NSSet)

    @objc(removeStarships:)
    @NSManaged public func removeFromStarships(_ values: NSSet)

}

extension People : Identifiable {

}
