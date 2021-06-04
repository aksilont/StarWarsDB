//
//  AbstarctVehicle+CoreDataProperties.swift
//  StarWarsDB
//
//  Created by Aksilont on 04.06.2021.
//
//

import Foundation
import CoreData

extension AbstarctVehicle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AbstarctVehicle> {
        return NSFetchRequest<AbstarctVehicle>(entityName: "AbstarctVehicle")
    }

    @NSManaged public var cargoCapacity: Int64
    @NSManaged public var consumables: String?
    @NSManaged public var costInCredits: Int64
    @NSManaged public var created: Date?
    @NSManaged public var crew: Int64
    @NSManaged public var edited: Date?
    @NSManaged public var filmIds: NSObject?
    @NSManaged public var id: Int16
    @NSManaged public var length: Float
    @NSManaged public var manufacturer: String?
    @NSManaged public var maxAtmospheringSpeed: Int64
    @NSManaged public var model: String?
    @NSManaged public var name: String?
    @NSManaged public var passengers: Int64
    @NSManaged public var pilotIds: NSObject?

}

extension AbstarctVehicle : Identifiable {

}
