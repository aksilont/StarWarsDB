//
//  KeyValueCell.swift
//  StarWarsDB
//
//  Created by Aksilont on 15.06.2021.
//

import UIKit

class KeyValueCell: UITableViewCell {
    
    private lazy var keyLabel: UILabel = UILabel()
    private lazy var valueLabel: UILabel = UILabel()
    
    func setData(key: String, value: String) {
        keyLabel.text = key
        valueLabel.text = value
    }
    
}
