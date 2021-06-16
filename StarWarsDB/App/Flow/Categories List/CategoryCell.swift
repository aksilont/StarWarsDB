//
//  CategoryCell.swift
//  StarWarsDB
//
//  Created by Aksilont on 14.06.2021.
//

import UIKit

class CategoryCell: UITableViewCell {

    private lazy var titleLabel: UILabel = UILabel()
    private lazy var iconImageView: UIImageView = UIImageView()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [iconImageView, titleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.spacing = 5.0
        return stackView
    }()
    
    var data: CategoryData? {
        didSet {
            titleLabel.text = data?.title
            iconImageView.image = data?.icon
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
        selectionStyle = .none
        
        contentView.addSubview(stackView)
        
        let padding: CGFloat = 10.0
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            contentView.topAnchor.constraint(equalTo: stackView.topAnchor, constant: -padding),
            contentView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: padding)
        ])
    }
    
}
