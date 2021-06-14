//
//  GroupCell.swift
//  StarWarsDB
//
//  Created by Aksilont on 15.06.2021.
//

import UIKit

class GroupCell: UITableViewCell {
    
    private lazy var nameLabel: UILabel = UILabel()
 
    var name: String? {
        didSet {
            nameLabel.text = name
        }
    }
    
}
