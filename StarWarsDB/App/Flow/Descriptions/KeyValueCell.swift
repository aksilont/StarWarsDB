//
//  KeyValueCell.swift
//  StarWarsDB
//
//  Created by Aksilont on 15.06.2021.
//

import UIKit

class KeyValueCell: UITableViewCell {
    
    private lazy var keyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [keyLabel, valueLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 20.0
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return stackView
    }()
    
    func setData(key: String, value: String) {
        keyLabel.text = key
        valueLabel.text = value
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
        addSubview(stackView)
        let padding: CGFloat = 30.0
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: padding),
            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding)
        ])
    }
    
}
