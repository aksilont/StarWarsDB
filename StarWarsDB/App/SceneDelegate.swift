//
//  SceneDelegate.swift
//  StarWarsDB
//
//  Created by Aksilont on 03.06.2021.
//

import UIKit
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = MainViewController()
        window.makeKeyAndVisible()
        self.window = window
        
        let context = CoreDataStack.shared.makePrivateContext()

        SWAPI.shared.getAll(.people) { data in
            self.perform(in: context) {
                data.forEach { _ = People.makeOrUpdate(from: $0, in: context) }
            }
        }

        SWAPI.shared.getAll(.planets) { data in
            self.perform(in: context) {
                data.forEach { _ = Planet.makeOrUpdate(from: $0, in: context) }
            }
        }

        SWAPI.shared.getAll(.vehicles) { data in
            self.perform(in: context) {
                data.forEach { _ = Vehicle.makeOrUpdate(from: $0, in: context) }
            }
        }

        SWAPI.shared.getAll(.starships) { data in
            self.perform(in: context) {
                data.forEach { _ = Starship.makeOrUpdate(from: $0, in: context) }
            }
        }

        SWAPI.shared.getAll(.species) { data in
            self.perform(in: context) {
                data.forEach { _ = Species.makeOrUpdate(from: $0, in: context) }
            }
        }
        
/*
        let context = CoreDataStack.shared.mainContext

        let fetchRequest: NSFetchRequest<People> = People.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "name == %@", "R2-D2")
//        fetchRequest.predicate = NSPredicate(format: "(name CONTAINS[cd] %@) && (height > %i)", "Skywalker", 170)
//        fetchRequest.predicate = NSPredicate(format: "height > %i", 100)
//
//        fetchRequest.sortDescriptors = [
//            NSSortDescriptor(keyPath: \People.height, ascending: false),
//            NSSortDescriptor(key: #keyPath(People.name), ascending: true)
//        ]
//
        context.perform {
            do {
                let results = try fetchRequest.execute()
                if !results.isEmpty {
                    results.forEach { item in
//                        (item.species as? Set<Species>)?.forEach {
//                            print(item.name ?? "", $0.name ?? "")
//                        }
                        (item.starships as? Set<Starship>)?.forEach {
                            print(item.name ?? "", $0.name ?? "")
                        }
                    }
                }
            } catch let error as NSError {
                print(error.userInfo)
            }
        }
 */
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        CoreDataStack.shared.saveToStore()
    }

    private func perform(in context: NSManagedObjectContext, closure: @escaping () -> Void) {
        context.perform {
            closure()
            
            do {
                if context.hasChanges {
                    try context.save()
                    debugPrint("Context changes saved")
                } else {
                    debugPrint("Context has no changes")
                }
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
    }
    
}
