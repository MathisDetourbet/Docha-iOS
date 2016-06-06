//
//  PreferencesTableViewCells.swift
//  Docha
//
//  Created by Mathis D on 06/06/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

class PreferencesNormalTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryFavoriteLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
}

class PreferencesSwitchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
}