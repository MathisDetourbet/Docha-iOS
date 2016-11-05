//
//  RoundFull.swift
//  Docha
//
//  Created by Mathis D on 10/10/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation
import SwiftyJSON

class RoundFull: Round {
    
    var products: [Product] = []
    var proposedCategories: [Category]
    var propositions: [Proposition]?
    var userTime: UInt?
    var opponentTime: UInt?
    
    init(id: Int, status: RoundStatus, products: [Product], category: Category?, winner: String?, proposedCategories: [Category], propositions: [Proposition]?, userScore: UInt?, userTime: UInt?, opponentScore: UInt?, opponentTime: UInt?, userPlayed: Bool, opponentPlayed: Bool) {
        
        self.products = products
        self.proposedCategories = proposedCategories
        self.propositions = propositions
        self.userTime = userTime
        self.opponentTime = opponentTime
        
        super.init(id: id, status: status, category: category, userScore: userScore, opponentScore: opponentScore, userPlayed: userPlayed, opponentPlayed: opponentPlayed, winner: winner)
    }
    
    convenience init(jsonObject: JSON) {
        let id = jsonObject[RoundDataKey.kId].intValue
        let status = RoundStatus(rawValue: jsonObject[RoundDataKey.kStatus].stringValue)!
        let productsArrayJSON = jsonObject[RoundDataKey.kProducts].array
        let userPlayed = jsonObject[RoundDataKey.kUserPlayed].boolValue
        let opponentPlayed = jsonObject[RoundDataKey.kOpponentPlayed].boolValue
        let winner = jsonObject[RoundDataKey.kWinner].string
        
        let category = Category(jsonObject: jsonObject[RoundDataKey.kCategory])
        
        var products: [Product] = []
        for productJSON in productsArrayJSON! {
            let product = Product(jsonObject: productJSON)
            products.append(product)
        }
        
        var proposedCategories: [Category] = []
        
        for categoryJSON in jsonObject[RoundDataKey.kProposedCategories].arrayValue {
            let category = Category(jsonObject: categoryJSON)
            if let category = category {
                proposedCategories.append(category)
            }
        }
        
        var propositions: [Proposition] = []
        if let propositionsJSON = jsonObject[RoundDataKey.kPropositions].array {
            for propositionJSON in propositionsJSON {
                let proposition = Proposition(jsonObject: propositionJSON)
                propositions.append(proposition)
            }
        }
        
        let userScore = jsonObject[RoundDataKey.kUserScore].uInt
        let userTime = jsonObject[RoundDataKey.kUserTime].uInt
        let opponentScore = jsonObject[RoundDataKey.kOpponentScore].uInt
        let opponentTime = jsonObject[RoundDataKey.kOpponentTime].uInt
        
        self.init(id: id, status: status, products: products, category: category, winner: winner, proposedCategories: proposedCategories, propositions: propositions, userScore: userScore, userTime: userTime, opponentScore: opponentScore, opponentTime: opponentTime, userPlayed: userPlayed, opponentPlayed: opponentPlayed)
    }
}
