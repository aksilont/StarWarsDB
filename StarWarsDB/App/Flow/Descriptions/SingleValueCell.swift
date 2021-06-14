//
//  SingleValueCell.swift
//  StarWarsDB
//
//  Created by Aksilont on 15.06.2021.
//

import UIKit

class SingleValueCell: UITableViewCell {
    
    private lazy var valueLabel: UILabel = UILabel()
    
    var value: String? {
        didSet {
            valueLabel.text = value
        }
    }
    
}
