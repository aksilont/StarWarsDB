//
//  DescriptionBuilder.swift
//  StarWarsDB
//
//  Created by Aksilont on 15.06.2021.
//

import Foundation

enum DescriptionElement {
    case group(name: String)
    case keyValue(name: String, value: String)
    case singleValue(value: String)
}

final class DescriptionBuilder {
    
    func build(for modelType: ModelType, from object: AnyObject) -> [DescriptionElement] {
        switch modelType {
        case .people:
            guard let item = object as? People else { return [] }
            return build(from: item)
        case .films:
            return []
        case .planets:
            guard let item = object as? Planet else { return [] }
            return build(from: item)
        case .species:
            guard let item = object as? Species else { return [] }
            return build(from: item)
        case .starships:
            guard let item = object as? Starship else { return [] }
            return build(from: item)
        case .vehicles:
            guard let item = object as? Vehicle else { return [] }
            return build(from: item)
        }
    }
    
    func build(from people: People) -> [DescriptionElement] {
        var elements = [DescriptionElement]()
        
        elements.append(.group(name: "General"))
        elements.append(.keyValue(name: "Birth year:", value: people.birthYear ?? "unknown"))
        elements.append(.keyValue(name: "Gender:", value: people.gender ?? "unknown"))
        elements.append(.keyValue(name: "Homeworld:", value: people.homeworld?.name ?? "unknown"))
        elements.append(.keyValue(name: "Height:", value: people.height.toNonNegativeString))
        elements.append(.keyValue(name: "Mass:", value: people.mass.toNonNegativeString))
        elements.append(.keyValue(name: "Eye color:", value: people.eyeColor ?? "unknown"))
        elements.append(.keyValue(name: "Hair color:", value: people.hairColor ?? "unknown"))
        elements.append(.keyValue(name: "Skin color:", value: people.skinColor ?? "unknown"))

        if people.species?.isNotEmpty == true {
            elements.append(.group(name: "Species"))
            
            (people.species as? Set<Species>)?
                .compactMap { $0.name }
                .forEach { elements.append(.singleValue(value: $0)) }
        }
        
        if people.starships?.isNotEmpty == true {
            elements.append(.group(name: "Starships"))
            
            (people.starships as? Set<Starship>)?
                .compactMap { $0.name }
                .forEach { elements.append(.singleValue(value: $0)) }
        }
        
        if people.vehicles?.isNotEmpty == true {
            elements.append(.group(name: "Vehicles"))
            
            (people.vehicles as? Set<Vehicle>)?
                .compactMap { $0.name }
                .forEach { elements.append(.singleValue(value: $0)) }
        }
        
        return elements
    }
    
    func build(from starship: Starship) -> [DescriptionElement] {
        var elements = [DescriptionElement]()
        
        elements.append(.group(name: "General"))
        elements.append(.keyValue(name: "Class:", value: starship.starshipClass ?? "unknown"))
        elements.append(.keyValue(name: "Model:", value: starship.model ?? "unknown"))
        elements.append(.keyValue(name: "MGLT:", value: starship.mglt.toNonNegativeString))
        elements.append(.keyValue(name: "max ATS:", value: starship.maxAtmospheringSpeed.toNonNegativeString))
        elements.append(.keyValue(name: "Cost:", value: starship.cost.toNonNegativeString))
        elements.append(.keyValue(name: "Hyperdrive", value: starship.hyperdriveRating.toNonNegativeString))
        elements.append(.keyValue(name: "Length:", value: starship.length.toNonNegativeString))
        elements.append(.keyValue(name: "Crew:", value: starship.crew.toNonNegativeString))
        elements.append(.keyValue(name: "Passengers:", value: starship.passengers.toNonNegativeString))
        elements.append(.keyValue(name: "Cargo:", value: starship.cargoCapacity.toNonNegativeString))
        elements.append(.keyValue(name: "Manufacturer:", value: starship.manufacturer ?? "unknown"))

        if starship.pilots?.isNotEmpty == true {
            elements.append(.group(name: "Pilots"))
            
            (starship.pilots as? Set<People>)?
                .compactMap { $0.name }
                .forEach { elements.append(.singleValue(value: $0)) }
        }
        
        return elements
    }
    
    func build(from item: Vehicle) -> [DescriptionElement] {
        var elements = [DescriptionElement]()
        
        elements.append(.group(name: "General"))
        elements.append(.keyValue(name: "Class:", value: item.vehicleClass ?? "unknown"))
        elements.append(.keyValue(name: "Model:", value: item.model ?? "unknown"))
        elements.append(.keyValue(name: "max ATS:", value: item.maxAtmospheringSpeed.toNonNegativeString))
        elements.append(.keyValue(name: "Cost:", value: item.cost.toNonNegativeString))
        elements.append(.keyValue(name: "Length:", value: item.length.toNonNegativeString))
        elements.append(.keyValue(name: "Crew:", value: item.crew.toNonNegativeString))
        elements.append(.keyValue(name: "Passengers:", value: item.passengers.toNonNegativeString))
        elements.append(.keyValue(name: "Cargo:", value: item.cargoCapacity.toNonNegativeString))
        elements.append(.keyValue(name: "Manufacturer:", value: item.manufacturer ?? "unknown"))

        if item.pilots?.isNotEmpty == true {
            elements.append(.group(name: "Pilots"))
            
            (item.pilots as? Set<People>)?
                .compactMap { $0.name }
                .forEach { elements.append(.singleValue(value: $0)) }
        }
        
        return elements
    }
    
    func build(from item: Planet) -> [DescriptionElement] {
        var elements = [DescriptionElement]()
        
        elements.append(.group(name: "General"))
        elements.append(.keyValue(name: "Name:", value: item.name ?? "unknown"))
        elements.append(.keyValue(name: "Diameter:", value: item.diameter.toNonNegativeString))
        elements.append(.keyValue(name: "Rotation period:", value: item.rotationPeriod.toNonNegativeString))
        elements.append(.keyValue(name: "Orbital period:", value: item.orbitalPeriod.toNonNegativeString))
        elements.append(.keyValue(name: "Gravity:", value: item.gravity ?? "unknown"))
        elements.append(.keyValue(name: "Population", value: item.popultaion.toNonNegativeString))
        elements.append(.keyValue(name: "Climate:", value: item.climate ?? "unknown"))
        elements.append(.keyValue(name: "Terrain:", value: item.terrain ?? "unknown"))
        elements.append(.keyValue(name: "Surface Water:", value: item.surfaceWater.toNonNegativeString))

        if item.residents?.isNotEmpty == true {
            elements.append(.group(name: "Residents"))
            
            (item.residents as? Set<People>)?
                .compactMap { $0.name }
                .forEach { elements.append(.singleValue(value: $0)) }
        }
        
        return elements
    }
    
    func build(from item: Species) -> [DescriptionElement] {
        var elements = [DescriptionElement]()
        
        elements.append(.group(name: "General"))
        elements.append(.keyValue(name: "Name:", value: item.name ?? "unknown"))
        elements.append(.keyValue(name: "Classification:", value: item.classification ?? "unknown"))
        elements.append(.keyValue(name: "Designation:", value: item.designation ?? "unknown"))
        elements.append(.keyValue(name: "Average height:", value: item.averageHeight.toNonNegativeString))
        elements.append(.keyValue(name: "Average lifespan:", value: item.averageLifespan.toNonNegativeString))
        elements.append(.keyValue(name: "Eye colors", value: item.eyeColors?.joined(separator: ", ") ?? "unknown"))
        elements.append(.keyValue(name: "Hair colors:", value: item.hairColors?.joined(separator: ", ") ?? "unknown"))
        elements.append(.keyValue(name: "Skin colors:", value: item.skinColors?.joined(separator: ", ") ?? "unknown"))
        elements.append(.keyValue(name: "Language:", value: item.language ?? "unknown"))
        elements.append(.keyValue(name: "Homeworld:", value: item.homeworld?.name ?? "unknown"))

        if item.peoples?.isNotEmpty == true {
            elements.append(.group(name: "Peoples"))
            
            (item.peoples as? Set<People>)?
                .compactMap { $0.name }
                .forEach { elements.append(.singleValue(value: $0)) }
        }
        
        return elements
    }
    
}
