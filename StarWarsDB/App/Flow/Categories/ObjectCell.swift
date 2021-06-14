//
//  ObjectCell.swift
//  StarWarsDB
//
//  Created by Aksilont on 14.06.2021.
//

import UIKit

class ObjectCell: UITableViewCell {
    
    private lazy var nameLabel: UILabel = UILabel()
    
    var name: String? {
        didSet {
            nameLabel.text = name
        }
    }
    
    var id: Int16?
    
    override func prepareForReuse() {
        name = nil
    }
    
}
