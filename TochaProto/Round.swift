//
//  Round.swift
//  Docha
//
//  Created by Mathis D on 09/10/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation
import SwiftyJSON

enum RoundStatus: String {
    case won = "won"
    case lost = "lost"
    case tie = "tie"
    case waiting = "waiting"
}

class Round {
    
    var id: Int
    var status: RoundStatus
    var products: [Product]
    var category: Category?
    var userScore: UInt?
    var opponentScore: UInt?
    var winner: String?
    
    init(id: Int, status: RoundStatus, products: [Product], category: Category?, userScore: UInt?, opponentScore: UInt?, winner: String?) {
        self.id = id
        self.status = status
        self.products = products
        self.category = category
        self.userScore = userScore
        self.opponentScore = opponentScore
        self.winner = winner
    }
    
    convenience init(jsonObject: JSON) {
        let id = jsonObject[RoundDataKey.kId].intValue
        let status = RoundStatus(rawValue: jsonObject[RoundDataKey.kStatus].stringValue)!
        let productsArrayJSON = jsonObject[RoundDataKey.kProducts].array
        let userScore = jsonObject[RoundDataKey.kUserScore].uInt
        let opponentScore = jsonObject[RoundDataKey.kOpponentScore].uInt
        let winner = jsonObject[RoundDataKey.kWinner].string
        
        let category = Category(jsonObject: jsonObject[RoundDataKey.kCategory])
        
        var products: [Product] = []
        for productJSON in productsArrayJSON! {
            let product = Product(jsonObject: productJSON)
            products.append(product)
        }
        
        self.init(id: id, status: status, products: products, category: category, userScore: userScore, opponentScore: opponentScore, winner: winner)
    }
    
    class func getEmptyRound() -> Round {
        return Round(id: 0, status: .waiting, products: [], category: nil, userScore: nil, opponentScore: nil, winner: nil)
    }
}
