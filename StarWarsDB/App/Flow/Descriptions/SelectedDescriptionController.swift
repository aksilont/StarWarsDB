//
//  SelectedDescriptionController.swift
//  StarWarsDB
//
//  Created by Aksilont on 18.06.2021.
//

import UIKit

class SelectedDescriptionController<T>: UITableViewController {

    private var elements = [DescriptionElement]()
    
    func setObjectId(_ id: Int16) {
        // TODO
        DataRepository.shared.fetchStarship(with: id) { [weak self] item in
            self?.elements = DescriptionBuilder().build(from: item)
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Lyfe cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.register(GroupCell.self, forCellReuseIdentifier: "GroupCell")
        tableView.register(KeyValueCell.self, forCellReuseIdentifier: "KeyValueCell")
        tableView.register(SingleValueCell.self, forCellReuseIdentifier: "SingleValueCell")
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = elements[indexPath.row]
        var cell = UITableViewCell()
        
        switch item {
        case let .group(name):
            cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath)
            (cell as? GroupCell)?.name = name
        case let .keyValue(name, value):
            cell = tableView.dequeueReusableCell(withIdentifier: "KeyValueCell", for: indexPath)
            (cell as? KeyValueCell)?.setData(key: name, value: value)
        case let .singleValue(value):
            cell = tableView.dequeueReusableCell(withIdentifier: "SingleValueCell", for: indexPath)
            (cell as? SingleValueCell)?.value = value
        }
        
        return cell
    }
    
    // TODO
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}
