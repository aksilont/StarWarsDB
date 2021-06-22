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
    
    func build<T>(for modelType: ModelType, from object: T) -> [DescriptionElement] {
        switch modelType {
        case .people:
            guard let item = object as? People else { return [] }
            return build(from: item)
        case .films:
            return []
        case .planets:
            return []
        case .species:
            return []
        case .starships:
            guard let item = object as? Starship else { return [] }
            return build(from: item)
        case .vehicles:
            return []
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
        elements.append(.keyValue(name: "Cost:", value: starship.costInCredits.toNonNegativeString))
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
    
}
