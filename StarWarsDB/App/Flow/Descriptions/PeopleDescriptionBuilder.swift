//
//  PeopleDescriptionBuilder.swift
//  StarWarsDB
//
//  Created by Aksilont on 15.06.2021.
//

import Foundation

final class PeopleDescriptionBuilder {
    
}

enum DescriptionElement {
    case group(name: String)
    case keyValue(name: String, value: String)
    case singleValue(value: String)
}
