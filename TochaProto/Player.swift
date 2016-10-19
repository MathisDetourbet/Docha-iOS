//
//  Player.swift
//  Docha
//
//  Created by Mathis D on 10/10/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation
import SwiftyJSON

enum PlayerType {
    case defaultPlayer
    case facebookPlayer
    case emailPlayer
}

class Player {
    var pseudo: String
    var gender: Gender
    var avatarUrl: String
    var avatarImage: UIImage?
    var playerType: PlayerType
    var level: Int?
    var dochos: Int
    
    init(pseudo: String, gender: Gender, avatarUrl: String, avatarImage: UIImage? = nil, playerType: PlayerType, level: Int?, dochos: Int) {
        self.pseudo = pseudo
        self.gender = gender
        self.avatarUrl = avatarUrl
        self.avatarImage = avatarImage
        self.playerType = playerType
        self.level = level
        self.dochos = dochos
    }
    
    convenience init(jsonObject: JSON) {
        
        if jsonObject == nil {
            let defaultPlayer = Player.defaultPlayer()
            self.init(pseudo: defaultPlayer.pseudo, gender: defaultPlayer.gender, avatarUrl: defaultPlayer.avatarUrl, playerType: .defaultPlayer, level: nil, dochos: 0)
            return
        }
        
        let pseudo = jsonObject[UserDataKey.kUsername].stringValue
        let gender = Gender(rawValue: jsonObject[UserDataKey.kGender].stringValue) ?? .universal
        let level = jsonObject[UserDataKey.kLevelMaxUnlocked].int
        let dochos = jsonObject[UserDataKey.kDochos].intValue
        
        var avatarUrl: String!
        var playerType: PlayerType?
        
        if let avatarUrlUnwrapped = jsonObject[UserDataKey.kAvatarUrl].string {
            avatarUrl = avatarUrlUnwrapped
            if avatarUrl.contains("https://graph.facebook.com/") {
                playerType = .facebookPlayer
                
            } else {
                playerType = .emailPlayer
            }
            
        } else {
            avatarUrl = Player.getAvatarDochaPath(for: gender)
            playerType = .defaultPlayer
        }
        
        self.init(pseudo: pseudo, gender: gender, avatarUrl: avatarUrl, playerType: playerType!, level: level, dochos: dochos)
    }
    
    convenience init(player: Player) {
        self.init(pseudo: player.pseudo, gender: player.gender, avatarUrl: player.avatarUrl, avatarImage: player.avatarImage, playerType: player.playerType, level: player.level, dochos: player.dochos)
    }
    
    class func getAvatarDochaPath(for gender: Gender) -> String {
        switch gender {
            case .male:     return "avatar_man"
            case .female:   return "avatar_woman"
            default:        return "avatar_man"
        }
    }
    
    class func defaultPlayer() -> Player {
        return Player(pseudo: "Docher", gender: .universal, avatarUrl: "avatar_man", playerType: .defaultPlayer, level: nil, dochos: 0)
    }
}
