//
//  DebriefTableViewCell.swift
//  Docha
//
//  Created by Mathis D on 23/06/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

protocol DebriefCellDelegate {
    func discoverProductActionWithURL(_ url: String)
}

class DebriefTableViewCell: UITableViewCell {
    
    var productLink: String?
    var delegate: DebriefCellDelegate?
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productBrandNameLabel: UILabel!
    @IBOutlet weak var dochosLabel: UILabel!
    @IBOutlet weak var heartLabel: UILabel!
    @IBOutlet weak var userEstimationLabel: UILabel!
    
    @IBAction func discoverProductButtonTouched(_ sender: UIButton) {
        delegate?.discoverProductActionWithURL(self.productLink!)
    }
}
