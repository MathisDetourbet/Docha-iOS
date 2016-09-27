//
//  DoubleHelper.swift
//  Docha
//
//  Created by Mathis D on 25/07/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func roundToPlaces(_ places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(self * divisor) / divisor
    }
}
