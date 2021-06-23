//
//  Species+CoreDataProperties.swift
//  StarWarsDB
//
//  Created by Aksilont on 06.06.2021.
//
//

import Foundation
import CoreData

extension Species {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Species> {
        return NSFetchRequest<Species>(entityName: "Species")
    }

    @NSManaged public var averageHeight: Float
    @NSManaged public var averageLifespan: Int16
    @NSManaged public var classification: String?
    @NSManaged public var created: Date?
    @NSManaged public var designation: String?
    @NSManaged public var edited: Date?
    @NSManaged public var eyeColors: [String]?
    @NSManaged public var filmIds: [Int]?
    @NSManaged public var hairColors: [String]?
    @NSManaged public var homeworldId: Int16
    @NSManaged public var id: Int16
    @NSManaged public var language: String?
    @NSManaged public var name: String?
    @NSManaged public var peopleIds: [Int]?
    @NSManaged public var skinColors: [String]?
    @NSManaged public var homeworld: Planet?
    @NSManaged public var peoples: NSSet?

}

// MARK: Generated accessors for peoples
extension Species {

    @objc(addPeoplesObject:)
    @NSManaged public func addToPeoples(_ value: People)

    @objc(removePeoplesObject:)
    @NSManaged public func removeFromPeoples(_ value: People)

    @objc(addPeoples:)
    @NSManaged public func addToPeoples(_ values: NSSet)

    @objc(removePeoples:)
    @NSManaged public func removeFromPeoples(_ values: NSSet)

}

extension Species : Identifiable {

}
