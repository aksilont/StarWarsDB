//
//  Vehicle+CoreDataProperties.swift
//  StarWarsDB
//
//  Created by Aksilont on 04.06.2021.
//
//

import Foundation
import CoreData

extension Vehicle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Vehicle> {
        return NSFetchRequest<Vehicle>(entityName: "Vehicle")
    }

    @NSManaged public var vehicleClass: String?
    @NSManaged public var pilots: NSSet?

}

// MARK: Generated accessors for pilots
extension Vehicle {

    @objc(addPilotsObject:)
    @NSManaged public func addToPilots(_ value: People)

    @objc(removePilotsObject:)
    @NSManaged public func removeFromPilots(_ value: People)

    @objc(addPilots:)
    @NSManaged public func addToPilots(_ values: NSSet)

    @objc(removePilots:)
    @NSManaged public func removeFromPilots(_ values: NSSet)

}
