//
//  GroupCell.swift
//  StarWarsDB
//
//  Created by Aksilont on 15.06.2021.
//

import UIKit

class GroupCell: UITableViewCell {
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.numberOfLines = 1
        return label
    }()
 
    var name: String? {
        didSet {
            nameLabel.text = name
        }
    }
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private func setupUI() {
        addSubview(nameLabel)
        
        let padding: CGFloat = 10.0
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: padding),
            nameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding)
        ])
    }
    
}
