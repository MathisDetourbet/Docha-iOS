//
//  TutorialOneView.swift
//  Docha
//
//  Created by Mathis D on 19/09/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

protocol TutorialViewDelegate {
    func nextButtonTouched()
}

class TutorialView: UIView {
    
    var delegate: TutorialViewDelegate?
    
    @IBAction func nextButtonTouched(sender: UIButton) {
        self.delegate?.nextButtonTouched()
    }
}