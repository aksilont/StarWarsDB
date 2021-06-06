//
//  Planet+CoreDataProperties.swift
//  StarWarsDB
//
//  Created by Aksilont on 06.06.2021.
//
//

import Foundation
import CoreData

extension Planet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Planet> {
        return NSFetchRequest<Planet>(entityName: "Planet")
    }

    @NSManaged public var climate: String?
    @NSManaged public var created: Date?
    @NSManaged public var diameter: Int32
    @NSManaged public var edited: Date?
    @NSManaged public var filmIds: [Int]?
    @NSManaged public var gravity: String?
    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var orbitalPeriod: Int16
    @NSManaged public var popultaion: Int64
    @NSManaged public var residentIds: [Int]?
    @NSManaged public var rotationPeriod: Int16
    @NSManaged public var surfaceWater: Int16
    @NSManaged public var terrain: String?
    @NSManaged public var residents: NSSet?

}

// MARK: Generated accessors for residents
extension Planet {

    @objc(addResidentsObject:)
    @NSManaged public func addToResidents(_ value: People)

    @objc(removeResidentsObject:)
    @NSManaged public func removeFromResidents(_ value: People)

    @objc(addResidents:)
    @NSManaged public func addToResidents(_ values: NSSet)

    @objc(removeResidents:)
    @NSManaged public func removeFromResidents(_ values: NSSet)

}

extension Planet : Identifiable {

}
