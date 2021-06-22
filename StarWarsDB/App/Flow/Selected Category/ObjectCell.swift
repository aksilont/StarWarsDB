//
//  ObjectCell.swift
//  StarWarsDB
//
//  Created by Aksilont on 14.06.2021.
//

import UIKit

class ObjectCell: UITableViewCell {
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    
    var name: String? {
        didSet {
            nameLabel.text = name
        }
    }
    
    var id: Int16?
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    override func prepareForReuse() {
        name = nil
    }
    
    private func setupUI() {
        selectionStyle = .none
        addSubview(nameLabel)
        
        let padding: CGFloat = 20.0
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: padding),
            nameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding)
        ])
    }
    
}
