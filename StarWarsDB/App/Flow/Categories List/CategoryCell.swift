//
//  CategoryCell.swift
//  StarWarsDB
//
//  Created by Aksilont on 14.06.2021.
//

import UIKit

class CategoryCell: UITableViewCell {

    private lazy var titleLabel: UILabel? = UILabel()
    private lazy var iconImageView: UIImageView? = UIImageView()
    
    var data: CategoryData? {
        didSet {
            titleLabel?.text = data?.title
            iconImageView?.image = data?.icon
        }
    }

}
