//
//  DescriptionBuilder.swift
//  StarWarsDB
//
//  Created by Aksilont on 15.06.2021.
//

import Foundation

final class DescriptionBuilder {
    
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
    
}

enum DescriptionElement {
    case group(name: String)
    case keyValue(name: String, value: String)
    case singleValue(value: String)
}
