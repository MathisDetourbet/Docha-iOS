//
//  Match.swift
//  Docha
//
//  Created by Mathis D on 09/10/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation
import SwiftyJSON

enum MatchStatus: String {
    case userTurn = "user_turn"
    case opponentTurn = "opponent_turn"
    case waiting = "waiting"
    case won = "won"
    case lost = "lost"
    case tie = "tie"
}

class Match {
    
    var id: Int
    var rounds: [Round]
    var opponent: Player
    var maxRounds: Int
    var status: MatchStatus
    var userScore: Int?
    var opponentScore: Int?
    
    init(id: Int, rounds: [Round], opponent: Player, maxRounds: Int, status: MatchStatus, userScore: Int?, opponentScore: Int?) {
        self.id = id
        self.rounds = rounds
        self.opponent = opponent
        self.maxRounds = maxRounds
        self.status = status
        self.userScore = userScore
        self.opponentScore = opponentScore
    }
    
    convenience init(jsonObject: JSON) {
        let id = jsonObject[MatchDataKey.kId].intValue
        let roundsJSONArray = jsonObject[MatchDataKey.kRounds].array
        let opponent = Player(jsonObject: jsonObject[MatchDataKey.kOpponent])
        let maxRounds = jsonObject[MatchDataKey.kMaxRounds].intValue
        let status = MatchStatus(rawValue: jsonObject[MatchDataKey.kStatus].stringValue)!
        let userScore = jsonObject[MatchDataKey.kUserScore].int
        let opponentScore = jsonObject[MatchDataKey.kOpponentScore].int
        
        var rounds: [Round] = []
        for roundJSON in roundsJSONArray! {
            let round = Round(jsonObject: roundJSON)
            rounds.append(round)
        }
        
        self.init(id: id, rounds: rounds, opponent: opponent, maxRounds: maxRounds, status: status, userScore: userScore, opponentScore: opponentScore)
    }
    
    func getMatchResult() -> MatchResult? {
        guard let userScore = self.userScore, let opponentScore = self.opponentScore else {
            return nil
        }
        
        if userScore > opponentScore {
            return MatchResult.won
            
        } else if userScore < opponentScore {
            return MatchResult.lost
            
        } else {
            return MatchResult.tie
        }
    }
}
