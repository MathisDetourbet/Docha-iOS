//
//  PreferencesTableViewCells.swift
//  Docha
//
//  Created by Mathis D on 06/06/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation

class PreferencesNormalTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

protocol PreferencesSwitchCellDelegate {
    func switchValueChanged(_ value: Bool)
}

class PreferencesSwitchTableViewCell: UITableViewCell {
    
    var delegate: PreferencesSwitchCellDelegate?
    
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        self.delegate?.switchValueChanged(sender.isOn)
    }
}
