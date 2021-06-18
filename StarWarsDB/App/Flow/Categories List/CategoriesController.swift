//
//  CategoriesController.swift
//  StarWarsDB
//
//  Created by Aksilont on 03.06.2021.
//

import UIKit

class CategoriesController: UITableViewController {
    
    private let data = [
        CategoryData(title: "Peoples", icon: #imageLiteral(resourceName: "icon_people"), category: .people),
        CategoryData(title: "Species", icon: #imageLiteral(resourceName: "icon_specie"), category: .species),
        CategoryData(title: "Planets", icon: #imageLiteral(resourceName: "icon-planet"), category: .planets),
        CategoryData(title: "Starhips", icon: #imageLiteral(resourceName: "icon-starship"), category: .starships),
        CategoryData(title: "Vehicles", icon: #imageLiteral(resourceName: "icon-vehicle"), category: .vehicles)
    ]
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI
    
    private func setupUI() {
        title = "Categories"
        tableView.register(CategoryCell.self, forCellReuseIdentifier: "CategoryCell")
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh,
                                                            target: self,
                                                            action: #selector(fetchAll))
    }
    
    @objc private func fetchAll() {
        ModelType.getAll().forEach { modelType in
            DataRepository.shared.fetchAll(for: modelType)
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as? CategoryCell
        else { return UITableViewCell() }
        cell.data = data[indexPath.row]
        return cell
    }

    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch data[indexPath.row].category {
        case .people:
            navigationItem.backButtonDisplayMode = .minimal
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.pushViewController(PeoplesController(), animated: true)
        case .films:
            break
        case .planets:
            break
        case .species:
            break
        case .starships:
            break
        case .vehicles:
            break
        }
    }
    
}

struct CategoryData {
    let title: String
    let icon: UIImage
    let category: ModelType
}
