//
//  NSManagedObject+Extensions.swift
//  StarWarsDB
//
//  Created by Aksilont on 09.06.2021.
//

import CoreData

extension NSManagedObject {
    
    static func getUniqueInstance(from id: Int16, in context: NSManagedObjectContext) -> Self {
        let fetchRequest = NSFetchRequest<Self>(entityName: String(describing: self))
        fetchRequest.predicate = NSPredicate(format: "id = %i", id)
        
        let results = try? fetchRequest.execute()
        
        guard let existed = results?.first else {
            debugPrint("Object created: \(type(of: self)) \(id)")
            return self.init(context: context)
        }
        
        return existed
    }
    
}
