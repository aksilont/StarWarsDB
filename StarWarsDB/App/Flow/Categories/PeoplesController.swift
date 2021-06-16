//
//  PeoplesController.swift
//  StarWarsDB
//
//  Created by Aksilont on 14.06.2021.
//

import UIKit
import CoreData

class PeoplesController: UITableViewController, NSFetchedResultsControllerDelegate {

    private lazy var resultsController: NSFetchedResultsController<People>? = {
        var resultController: NSFetchedResultsController<People>?
        
        CoreDataStack.shared.mainContext.performAndWait {
            let fetchRequest: NSFetchRequest<People> = People.fetchRequest()
            
            fetchRequest.sortDescriptors = [
                NSSortDescriptor(key: "name.firstLetter", ascending: true)
            ]
            
            let controller = NSFetchedResultsController(
                fetchRequest: fetchRequest,
                managedObjectContext: CoreDataStack.shared.mainContext,
                sectionNameKeyPath: "name.firstLetter",
                cacheName: nil
            )
            
            controller.delegate = self
            resultController = controller
        }
        
        return resultController
    }()
    
    // MARK: - Lyfe cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Peoples"
        
        tableView.register(ObjectCell.self, forCellReuseIdentifier: "ObjectCell")
        
        CoreDataStack.shared.mainContext.perform { [weak self] in
            try? self?.resultsController?.performFetch()
            self?.tableView.reloadData()
        }
        
        DataRepository.shared.fetchAll(for: .people)
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return resultsController?.sections?.count ?? 0
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return resultsController?.sectionIndexTitles
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return resultsController?.section(forSectionIndexTitle: title, at: index) ?? 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return SectionView(name: resultsController?.sections?[section].name ?? "")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ObjectCell", for: indexPath) as? ObjectCell
        else { return UITableViewCell() }
        cell.id = resultsController?.object(at: indexPath).id
        cell.name = resultsController?.object(at: indexPath).name
        return cell
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            tableView.reloadSections(IndexSet(integer: sectionIndex), with: .fade)
        @unknown default:
            fatalError("Unknown type for didChange sectionInfo: NSFetchedResultsSectionInfo")
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .fade)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .move:
            guard let indexPath = indexPath else { return }
            guard let newIndexPath = newIndexPath else { return }
            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .fade)
        @unknown default:
            fatalError("Unknown type for didChange anObject: Any")
        }
    }
    
}
