//
//  SelectedCategoryController.swift
//  StarWarsDB
//
//  Created by Aksilont on 18.06.2021.
//

import UIKit
import CoreData

protocol ObjectResultable {
    var id: Int16 { get set }
    var name: String? { get set }
}

class SelectedCategoryController<T: NSManagedObject & ObjectResultable>: UITableViewController,
                                                               NSFetchedResultsControllerDelegate,
                                                               UISearchResultsUpdating {
    
    private lazy var resultsController: NSFetchedResultsController<T>? = {
        var resultController: NSFetchedResultsController<T>?
        
        CoreDataStack.shared.mainContext.performAndWait {
            let fetchRequest: NSFetchRequest<T> = NSFetchRequest<T>(entityName: String(describing: T.self))
            
            fetchRequest.sortDescriptors = [
                NSSortDescriptor(key: "name.firstLetter", ascending: true)
            ]
            
            let controller = NSFetchedResultsController<T>(
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
        title = String(describing: T.self)
        
        setupUI()

        CoreDataStack.shared.mainContext.perform { [unowned self] in
            try? self.resultsController?.performFetch()
            self.tableView.reloadData()
        }
    }
    
    // MARK: - UI
    
    private func setupUI() {
        setupTableView()
        setupSearchController()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh,
                                                            target: self,
                                                            action: #selector(fetchCurrent))
    }
    
    private func setupTableView() {
        tableView.register(ObjectCell.self, forCellReuseIdentifier: "ObjectCell")
    }
    
    private func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    @objc private func fetchCurrent() {
        DataRepository.shared.fetchAll(for: .species)
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
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ObjectCell, let id = cell.id
        else { return }
        let descriptionController = SelectedDescriptionController<T>()
        descriptionController.title = cell.name
        descriptionController.setObjectId(id)
        navigationController?.pushViewController(descriptionController, animated: true)
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
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        if searchText.isEmpty {
            resultsController?.fetchRequest.predicate = nil
        } else {
            resultsController?.fetchRequest.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchText)
        }
        
        CoreDataStack.shared.mainContext.perform { [unowned self] in
            try? self.resultsController?.performFetch()
            self.tableView.reloadData()
        }
    }
}
