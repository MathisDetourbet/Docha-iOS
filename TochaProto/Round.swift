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
    var category: Category?
    var userScore: UInt?
    var opponentScore: UInt?
    var userPlayed: Bool
    var opponentPlayed: Bool
    var winner: String?
    
    init(id: Int, status: RoundStatus, category: Category?, userScore: UInt?, opponentScore: UInt?, userPlayed: Bool, opponentPlayed: Bool, winner: String?) {
        self.id = id
        self.status = status
        self.category = category
        self.userScore = userScore
        self.opponentScore = opponentScore
        self.userPlayed = userPlayed
        self.opponentPlayed = opponentPlayed
        self.winner = winner
    }
    
    convenience init(jsonObject: JSON) {
        let id = jsonObject[RoundDataKey.kId].intValue
        let status = RoundStatus(rawValue: jsonObject[RoundDataKey.kStatus].stringValue)!
        let userScore = jsonObject[RoundDataKey.kUserScore].uInt
        let opponentScore = jsonObject[RoundDataKey.kOpponentScore].uInt
        let userPlayed = jsonObject[RoundDataKey.kUserPlayed].boolValue
        let opponentPlayed = jsonObject[RoundDataKey.kOpponentPlayed].boolValue
        let winner = jsonObject[RoundDataKey.kWinner].string
        
        let category = Category(jsonObject: jsonObject[RoundDataKey.kCategory])
        
        self.init(id: id, status: status, category: category, userScore: userScore, opponentScore: opponentScore, userPlayed: userPlayed, opponentPlayed: opponentPlayed, winner: winner)
    }
    
    class func getEmptyRound() -> Round {
        return Round(id: 0, status: .waiting, category: nil, userScore: nil, opponentScore: nil, userPlayed: false, opponentPlayed: false, winner: nil)
    }
}
