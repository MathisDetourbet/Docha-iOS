//
//  Proposition.swift
//  Docha
//
//  Created by Mathis D on 10/10/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Proposition {
    var productID: Int
    var price: Double
    var timeStamp: Int
    
    init(productID: Int, price: Double, timeStamp: Int) {
        self.productID = productID
        self.price = price
        self.timeStamp = timeStamp
    }
    
    init(jsonObject: JSON) {
        let productID = jsonObject[PropositionDataKey.kProductID].intValue
        let price = jsonObject[PropositionDataKey.kPrice].doubleValue
        let timeStamp = jsonObject[PropositionDataKey.kTimeStamp].intValue
        
        self.init(productID: productID, price: price, timeStamp: timeStamp)
    }
    
    func generateJSONObject() -> [String: Any] {
        var json: [String: Any] = [:]
        json[PropositionDataKey.kProductID] = productID
        json[PropositionDataKey.kPrice] = price
        json[PropositionDataKey.kTimeStamp] = timeStamp
        
        return json
    }
}
