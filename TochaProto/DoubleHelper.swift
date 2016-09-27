//
//  DoubleHelper.swift
//  Docha
//
//  Created by Mathis D on 25/07/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

