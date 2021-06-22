//
//  ApplicationCoordinator.swift
//  StarWarsDB
//
//  Created by Aksilont on 22.06.2021.
//

import Foundation

final class ApplicationCoordinator: BaseCoordinator {
    
    override func start() {
        toCategoriesList()
    }
    
    private func toCategoriesList() {
        let coordinator = CategoriesCoordinator()
        addDependency(coordinator)
        coordinator.start()
    }
    
}
