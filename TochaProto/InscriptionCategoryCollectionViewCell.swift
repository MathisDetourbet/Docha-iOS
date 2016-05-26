//
//  InscriptionCategoryCollectionViewCell.swift
//  DochaProto
//
//  Created by Mathis D on 25/05/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

class InscriptionCategoryCollectionViewCell: UICollectionViewCell {
    
    var categoryName: String?
    
    var imageSelected: Bool = false {
        didSet {
            if imageSelected {
                self.categoryImageView.image = UIImage(named: "\(self.categoryName!)_selected")
            } else {
                self.categoryImageView.image = UIImage(named: self.categoryName!)
            }
        }
    }
    
    @IBOutlet weak var categoryImageView: UIImageView!
}