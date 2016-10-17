//
//  Player.swift
//  Docha
//
//  Created by Mathis D on 10/10/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation
import SwiftyJSON

class Player {
    var pseudo: String
    var gender: Gender
    var avatarUrl: String
    var avatarImage: UIImage?
    var isDefaultPlayer: Bool?
    var level: Int?
    var dochos: Int
    
    init(pseudo: String, gender: Gender, avatarUrl: String, avatarImage: UIImage? = nil, isDefaultPlayer: Bool?, level: Int?, dochos: Int) {
        self.pseudo = pseudo
        self.gender = gender
        self.avatarUrl = avatarUrl
        self.avatarImage = avatarImage
        self.isDefaultPlayer = isDefaultPlayer
        self.level = level
        self.dochos = dochos
    }
    
    convenience init(jsonObject: JSON) {
        
        if jsonObject == nil {
            let defaultPlayer = Player.defaultPlayer()
            self.init(pseudo: defaultPlayer.pseudo, gender: defaultPlayer.gender, avatarUrl: defaultPlayer.avatarUrl, isDefaultPlayer: true, level: nil, dochos: 0)
            return
        }
        
        let pseudo = jsonObject[UserDataKey.kAvatarUrl].stringValue
        let gender = Gender(rawValue: jsonObject[UserDataKey.kGender].stringValue) ?? .universal
        let level = jsonObject[UserDataKey.kLevelMaxUnlocked].int
        let dochos = jsonObject[UserDataKey.kDochos].intValue
        var avatarUrl: String!
        
        if let avatarUrlUnwrapped = jsonObject[UserDataKey.kAvatarUrl].string {
            avatarUrl = avatarUrlUnwrapped
            
        } else {
            avatarUrl = Player.getAvatarDochaPath(for: gender)
        }
        
        self.init(pseudo: pseudo, gender: gender, avatarUrl: avatarUrl, isDefaultPlayer: false, level: level, dochos: dochos)
    }
    
    convenience init(player: Player) {
        self.init(pseudo: player.pseudo, gender: player.gender, avatarUrl: player.avatarUrl, avatarImage: player.avatarImage, isDefaultPlayer: player.isDefaultPlayer, level: player.level, dochos: player.dochos)
    }
    
    class func getAvatarDochaPath(for gender: Gender) -> String {
        switch gender {
            case .male:     return "avatar_man"
            case .female:   return "avatar_woman"
            default:        return "avatar_man"
        }
    }
    
    class func defaultPlayer() -> Player {
        return Player(pseudo: "Docher", gender: .universal, avatarUrl: "avatar_man", isDefaultPlayer: true, level: nil, dochos: 0)
    }
}
