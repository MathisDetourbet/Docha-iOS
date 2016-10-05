//
//  InscriptionCategoryCollectionViewCell.swift
//  DochaProto
//
//  Created by Mathis D on 25/05/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation

class InscriptionCategoryCollectionViewCell: UICollectionViewCell {
    
    var categoryName: String! {
        didSet {
            categoryNameLabel.text = categoryName
        }
    }
    
    var imageSelected: Bool = false {
        didSet {
            if imageSelected {
                categoryImageView.image = UIImage(named: "\(categoryName!)_selected")
            } else {
                categoryImageView.image = UIImage(named: categoryName)
            }
        }
    }
    
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryNameLabel: UILabel!
}
