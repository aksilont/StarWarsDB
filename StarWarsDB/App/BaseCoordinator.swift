//
//  BaseCoordinator.swift
//  StarWarsDB
//
//  Created by Aksilont on 22.06.2021.
//

import UIKit

class BaseCoordinator {
    
    var childCoordinators: [BaseCoordinator] = []
    
    func start() {}
    
    func addDependency(_ coordinator: BaseCoordinator) {
        if childCoordinators.filter({ $0 === coordinator }).isEmpty { childCoordinators.append(coordinator) }
    }
    
    func removeDependency(_ coordinator: BaseCoordinator?) {
        guard childCoordinators.isEmpty == false, let coordinator = coordinator else { return }
        for (index, element) in childCoordinators.reversed().enumerated() where element === coordinator {
            childCoordinators.remove(at: index)
            break
        }
    }
    
    func setAsRoot(_ controller: UIViewController) {
        if #available(iOS 13, *) {
            let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
            sceneDelegate?.window?.rootViewController = controller
        } else {
            UIApplication.shared.keyWindow?.rootViewController = controller
        }
    }
    
}
