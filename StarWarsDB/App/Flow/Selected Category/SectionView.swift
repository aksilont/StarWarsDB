//
//  SectionView.swift
//  StarWarsDB
//
//  Created by Aksilont on 15.06.2021.
//

import UIKit

final class SectionView: UIView {
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    // MARK: - Init
    
    init(name: String) {
        super.init(frame: .zero)
        backgroundColor = .lightGray.withAlphaComponent(0.3)
        label.text = name
        addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = CGRect(
            x: bounds.minX + 15.0,
            y: bounds.minY,
            width: bounds.width - 15.0,
            height: bounds.height)
    }
    
}
