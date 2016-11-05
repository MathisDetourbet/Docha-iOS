//
//  Player.swift
//  Docha
//
//  Created by Mathis D on 10/10/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation
import SwiftyJSON
import Kingfisher

enum PlayerType {
    case defaultPlayer
    case facebookPlayer
    case emailPlayer
}

class Player {
    var pseudo: String
    var fullName: String?
    var gender: Gender
    var avatarUrl: String
    var avatarImage: UIImage?
    var playerType: PlayerType
    var level: Int? = 0
    var dochos: Int = 0
    var perfects: Int = 0
    var isOnline: Bool = false
    
    init(pseudo: String, fullName: String?, gender: Gender, avatarUrl: String, avatarImage: UIImage? = nil, playerType: PlayerType, level: Int?, dochos: Int, perfects: Int, isOnline: Bool) {
        self.pseudo = pseudo
        self.fullName = fullName
        self.gender = gender
        self.avatarUrl = avatarUrl
        self.avatarImage = avatarImage
        self.playerType = playerType
        self.level = level
        self.dochos = dochos
        self.perfects = perfects
        self.isOnline = isOnline
    }
    
    convenience init(jsonObject: JSON) {
        
        if jsonObject == nil {
            let defaultPlayer = Player.defaultPlayer()
            self.init(pseudo: defaultPlayer.pseudo, fullName: defaultPlayer.fullName, gender: defaultPlayer.gender, avatarUrl: defaultPlayer.avatarUrl, playerType: .defaultPlayer, level: nil, dochos: 0, perfects: defaultPlayer.perfects, isOnline: defaultPlayer.isOnline)
            return
        }
        
        let pseudo = jsonObject[UserDataKey.kUsername].stringValue
        let fullName = jsonObject[UserDataKey.kFullName].string
        let gender = Gender(rawValue: jsonObject[UserDataKey.kGender].stringValue) ?? .universal
        let level = jsonObject[UserDataKey.kLevelMaxUnlocked].int
        let dochos = jsonObject[UserDataKey.kDochos].intValue
        let perfects = jsonObject[UserDataKey.kPerfectPriceCpt].intValue
        let isOnline = jsonObject[UserDataKey.kIsOnline].boolValue
        
        var avatarUrl: String!
        var playerType: PlayerType?
        
        if let avatarUrlUnwrapped = jsonObject[UserDataKey.kAvatarUrl].string {
            avatarUrl = avatarUrlUnwrapped
            if avatarUrl.contains("https://graph.facebook.com/") {
                playerType = .facebookPlayer
                
            } else {
                avatarUrl = Player.getAvatarDochaPath(for: gender)
                playerType = .emailPlayer
            }
            
        } else {
            avatarUrl = Player.getAvatarDochaPath(for: gender)
            playerType = .emailPlayer
        }
        
        self.init(pseudo: pseudo, fullName: fullName, gender: gender, avatarUrl: avatarUrl, playerType: playerType!, level: level, dochos: dochos, perfects: perfects, isOnline: isOnline)
    }
    
    convenience init(player: Player) {
        self.init(pseudo: player.pseudo, fullName: player.fullName, gender: player.gender, avatarUrl: player.avatarUrl, avatarImage: player.avatarImage, playerType: player.playerType, level: player.level, dochos: player.dochos, perfects: player.perfects, isOnline: player.isOnline)
    }
    
    func getAvatarImage(for size: AvatarDochaSize = .medium, completionHandler completion: @escaping (_ image: UIImage) -> Void) {
        if let avatarImage = avatarImage {
            completion(avatarImage)
            return
            
        } else {
            if playerType == .defaultPlayer || playerType == .emailPlayer {
                let avatarPath = Player.getAvatarDochaPath(for: gender)
                completion(UIImage(named: "\(avatarPath)_\(size.rawValue)")!)
                
                return
                
            } else {
                let url = URL(string: avatarUrl)
                ImageDownloader.default.downloadImage(with: url!, options: [], progressBlock: nil,
                    completionHandler: { (image, error, _, _) in
                        
                        if error != nil {
                            debugPrint(error as! Error)
                            let avatarPath = Player.getAvatarDochaPath(for: self.gender)
                            completion(UIImage(named: "\(avatarPath)_\(size.rawValue)")!)
                            
                            return
                        }
                        
                        completion(image!)
                        return
                    }
                )
            }
        }
    }
    
    class func getAvatarDochaPath(for gender: Gender) -> String {
        switch gender {
            case .male:     return "avatar_man"
            case .female:   return "avatar_woman"
            default:        return "avatar_man"
        }
    }
    
    class func defaultPlayer() -> Player {
        return Player(pseudo: "Docher", fullName: nil, gender: .universal, avatarUrl: "avatar_man", playerType: .defaultPlayer, level: nil, dochos: 0, perfects: 0, isOnline: false)
    }
}
