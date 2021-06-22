//
//  CategoriesController.swift
//  StarWarsDB
//
//  Created by Aksilont on 03.06.2021.
//

import UIKit

struct CategoryData {
    
    let title: String
    let icon: UIImage
    let category: ModelType
    
    static func data() -> [CategoryData] {
        return [
            CategoryData(title: "Peoples", icon: #imageLiteral(resourceName: "icon_people"), category: .people),
            CategoryData(title: "Species", icon: #imageLiteral(resourceName: "icon_specie"), category: .species),
            CategoryData(title: "Planets", icon: #imageLiteral(resourceName: "icon-planet"), category: .planets),
            CategoryData(title: "Starhips", icon: #imageLiteral(resourceName: "icon-starship"), category: .starships),
            CategoryData(title: "Vehicles", icon: #imageLiteral(resourceName: "icon-vehicle"), category: .vehicles)
        ]
    }
    
}

class CategoriesController: UITableViewController {
    
    private let data = CategoryData.data()
    
    var onCategory: ((ModelType) -> Void)?
    
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
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.backButtonDisplayMode = .minimal
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
        onCategory?(data[indexPath.row].category)
    }
    
}
