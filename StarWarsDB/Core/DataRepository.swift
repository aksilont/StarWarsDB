import Foundation
import CoreData
import SwiftyJSON

typealias ManagedCoreDataModel = NSManagedObject & CoreDataModel

protocol CoreDataModel {
    static func makeOrUpdate(from json: JSON, in context: NSManagedObjectContext) -> Self?
}

extension People: CoreDataModel {}
extension Planet: CoreDataModel {}
extension Species: CoreDataModel {}
extension Starship: CoreDataModel {}
extension Vehicle: CoreDataModel {}

final class DataRepository {
    
    private let storage: CoreDataManager
    private let api: SWAPI
    
    static let shared: DataRepository = {
        return DataRepository(
            storage: CoreDataManager.shared,
            api: SWAPI.shared
        )
    }()
    
    init(storage: CoreDataManager, api: SWAPI) {
        self.storage = storage
        self.api = api
    }
    
    func getClass(for modelType: ModelType) -> ManagedCoreDataModel.Type? {
        switch modelType {
        case .people:
            return People.self
        case .films:
            return nil
        case .planets:
            return Planet.self
        case .species:
            return Species.self
        case .starships:
            return Starship.self
        case .vehicles:
            return Vehicle.self
        }
    }
    
    private func perform(in context: NSManagedObjectContext,
                         clousure: @escaping () -> Void,
                         completion: (() -> Void)? = nil) {
        context.perform {
            defer { completion?() }
            clousure()
            
            do {
                if context.hasChanges {
                    try context.save()
                    self.storage.saveToStore()
                    debugPrint("Context changes saved")
                } else {
                    debugPrint("Context has no changes")
                }
            } catch {
                debugPrint(error)
            }
        }
    }
    
    private func performAndWait(in context: NSManagedObjectContext,
                                clousure: @escaping () -> Void,
                                completion: (() -> Void)? = nil) {
        context.performAndWait {
            defer { completion?() }
            clousure()
            
            do {
                if context.hasChanges {
                    try context.save()
                    self.storage.saveToStore()
                    debugPrint("Context changes saved")
                } else {
                    debugPrint("Context has no changes")
                }
            } catch {
                debugPrint(error)
            }
        }
    }
    
}

// MARK: - Fetch data

extension DataRepository {
    
    func fetchAll(for modelType: ModelType, forceReload: Bool = true, completion: (() -> Void)? = nil) {
        let context = storage.backgroundContext
        
        context.perform {
            let modelClass = self.getClass(for: modelType)
            let resultsIsEmpty = (try? modelClass?.fetchRequest().execute().isEmpty ?? true) ?? true
            
            guard resultsIsEmpty || forceReload else {
                completion?()
                return
            }
            
            self.api.getAll(modelType) { data in
                self.perform(
                    in: context,
                    clousure: { data.forEach { _ = modelClass?.makeOrUpdate(from: $0, in: context) } },
                    completion: completion
                )
            }
        }
    }
    
    func fetch(model type: ModelType, with id: Int16, completion: @escaping (NSManagedObject) -> Void) {
        switch type {
        case .people:
            fetchPeople(with: id, completion: completion)
        case .films:
            break
        case .planets:
            fetchPlanet(with: id, completion: completion)
        case .species:
            fetchSpecies(with: id, completion: completion)
        case .starships:
            fetchStarship(with: id, completion: completion)
        case .vehicles:
            fetchVehicle(with: id, completion: completion)
        }
    }
    
    func fetchPeople(with id: Int16, completion: @escaping (People) -> Void) {
        let context = storage.backgroundContext

        context.perform {
            do {
                let request: NSFetchRequest<People> = People.fetchRequest()
                request.predicate = NSPredicate(format: "id = %u", id)
                
                var people = try request.execute().first
                
                if people == nil {
                    let data = try self.api.get(.people, withId: id.toInt)
                    people = People.makeOrUpdate(from: data, in: context)
                }
                
                if let homeworldId = people?.homeworldId, people?.homeworld == nil {
                    _ = Planet.makeOrUpdate(
                        from: try self.api.get(.planets, withId: homeworldId.toInt),
                        in: context
                    )
                }
                
                if let ids = people?.speciesIds, people?.species?.count == 0 {
                    try ids.forEach {
                        _ = Species.makeOrUpdate(
                            from: try self.api.get(.species, withId: $0),
                            in: context
                        )
                    }
                }
                
                if let ids = people?.starshipIds, people?.starships?.count == 0 {
                    try ids.forEach {
                        _ = Starship.makeOrUpdate(
                            from: try self.api.get(.starships, withId: $0),
                            in: context
                        )
                    }
                }
                
                if let ids = people?.vehicleIds, people?.vehicles?.count == 0 {
                    try ids.forEach {
                        _ = Vehicle.makeOrUpdate(
                            from: try self.api.get(.vehicles, withId: $0),
                            in: context
                        )
                    }
                }
                
                try context.save()
                
                guard let unwrapped = people else { return }
                completion(unwrapped)
            } catch {
                debugPrint("Can't fetch people with id \(id)")
            }
        }
    }
    
    func fetchStarship(with id: Int16, completion: @escaping (Starship) -> Void) {
        let context = storage.backgroundContext
        
        context.perform {
            do {
                let request: NSFetchRequest<Starship> = Starship.fetchRequest()
                request.predicate = NSPredicate(format: "id = %u", id)
                
                var starship = try request.execute().first
                
                if starship == nil {
                    let data = try self.api.get(.starships, withId: id.toInt)
                    starship = Starship.makeOrUpdate(from: data, in: context)
                }
                
                if let ids = starship?.pilotIds, starship?.pilots?.count == 0 {
                    try ids.forEach {
                        _ = People.makeOrUpdate(
                            from: try self.api.get(.people, withId: $0),
                            in: context
                        )
                    }
                }
                
                try context.save()
                
                guard let unwrapped = starship else { return }
                completion(unwrapped)
            } catch {
                debugPrint("Can't fetch starship with id \(id)")
            }
        }
    }
    
    func fetchVehicle(with id: Int16, completion: @escaping (Vehicle) -> Void) {
        let context = storage.backgroundContext
        
        context.perform {
            do {
                let request: NSFetchRequest<Vehicle> = Vehicle.fetchRequest()
                request.predicate = NSPredicate(format: "id = %u", id)
                
                var result = try request.execute().first
                
                if result == nil {
                    let data = try self.api.get(.vehicles, withId: id.toInt)
                    result = Vehicle.makeOrUpdate(from: data, in: context)
                }
                
                if let ids = result?.pilotIds, result?.pilots?.count == 0 {
                    try ids.forEach {
                        _ = People.makeOrUpdate(
                            from: try self.api.get(.people, withId: $0),
                            in: context
                        )
                    }
                }
                
                try context.save()
                
                guard let unwrapped = result else { return }
                completion(unwrapped)
            } catch {
                debugPrint("Can't fetch starship with id \(id)")
            }
        }
    }
    
    func fetchPlanet(with id: Int16, completion: @escaping (Planet) -> Void) {
        let context = storage.backgroundContext
        
        context.perform {
            do {
                let request: NSFetchRequest<Planet> = Planet.fetchRequest()
                request.predicate = NSPredicate(format: "id = %u", id)
                
                var result = try request.execute().first
                
                if result == nil {
                    let data = try self.api.get(.planets, withId: id.toInt)
                    result = Planet.makeOrUpdate(from: data, in: context)
                }
                
                if let ids = result?.residentIds, result?.residents?.count == 0 {
                    try ids.forEach {
                        _ = People.makeOrUpdate(
                            from: try self.api.get(.people, withId: $0),
                            in: context
                        )
                    }
                }
                
                try context.save()
                
                guard let unwrapped = result else { return }
                completion(unwrapped)
            } catch {
                debugPrint("Can't fetch planet with id \(id)")
            }
        }
    }
    
    func fetchSpecies(with id: Int16, completion: @escaping (Species) -> Void) {
        let context = storage.backgroundContext
        
        context.perform {
            do {
                let request: NSFetchRequest<Species> = Species.fetchRequest()
                request.predicate = NSPredicate(format: "id = %u", id)
                
                var result = try request.execute().first
                
                if result == nil {
                    let data = try self.api.get(.species, withId: id.toInt)
                    result = Species.makeOrUpdate(from: data, in: context)
                }
                
                if let ids = result?.peopleIds, result?.peoples?.count == 0 {
                    try ids.forEach {
                        _ = People.makeOrUpdate(
                            from: try self.api.get(.people, withId: $0),
                            in: context
                        )
                    }
                }
                
                try context.save()
                
                guard let unwrapped = result else { return }
                completion(unwrapped)
            } catch {
                debugPrint("Can't fetch species with id \(id)")
            }
        }
    }
    
}
