//
//  CategoriesCoordinator.swift
//  StarWarsDB
//
//  Created by Aksilont on 22.06.2021.
//

import UIKit

final class CategoriesCoordinator: BaseCoordinator {
    
    var rootController: UINavigationController?
    
    override func start() {
        showCategories()
    }
    
    private func showCategories() {
        let controller = CategoriesController()
        
        controller.onCategory = { [weak self ] modelType in
            self?.showSelectedCategory(modelType: modelType)
        }
        
        let rootController = UINavigationController(rootViewController: controller)
        setAsRoot(rootController)
        self.rootController = rootController
    }
    
    private func showSelectedCategory(modelType: ModelType) {
        var selectedController: UIViewController = UIViewController()
        switch modelType {
        case .people:
            selectedController = SelectedCategoryController<People>()
        case .films:
            break
        case .planets:
            selectedController = SelectedCategoryController<Planet>()
        case .species:
            selectedController = SelectedCategoryController<Species>()
        case .starships:
            selectedController = SelectedCategoryController<Starship>()
        case .vehicles:
            selectedController = SelectedCategoryController<Vehicle>()
        }
        rootController?.pushViewController(selectedController, animated: true)
    }
    
}
