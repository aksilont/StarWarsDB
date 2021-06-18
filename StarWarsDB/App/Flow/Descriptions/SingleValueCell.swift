//
//  SingleValueCell.swift
//  StarWarsDB
//
//  Created by Aksilont on 15.06.2021.
//

import UIKit

class SingleValueCell: UITableViewCell {
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    
    var value: String? {
        didSet {
            valueLabel.text = value
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
        addSubview(valueLabel)
        
        let padding: CGFloat = 30.0
        NSLayoutConstraint.activate([
            valueLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            valueLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: padding),
            valueLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding)
        ])
    }
}
