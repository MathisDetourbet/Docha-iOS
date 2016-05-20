//
//  CouponTableViewCell.swift
//  DochaProto
//
//  Created by Mathis D on 29/01/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

class CouponTableViewCell: UITableViewCell {
    
    @IBOutlet weak var brandImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categorieLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
