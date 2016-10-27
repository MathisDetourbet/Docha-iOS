//
//  User.swift
//  DochaProto
//
//  Created by Mathis D on 17/03/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation
import SwiftyJSON

class User: NSObject {
    var pseudo: String?
    var lastName: String?
    var firstName: String?
    var email: String?
    var gender: Gender?
    var dateBirthday: Date?
    var categoriesPrefered: [String] = []
    var avatarUrl: String?
    var levelMaxUnlocked: Int? = 1
    var levelPercentage: Double? = 0.0
    var dochos: Int = 0
    var experience: Int = 0
    var perfectPriceCpt: Int = 0
    var rank: UInt = 0
    var badgesUnlockedIdentifiers: [String]?
    var notifications: Bool = true
    var notificationTokens: [String] = []
    
    override init() {}
    
    init(pseudo: String?, lastName: String?, firstName: String?, email: String?, gender: Gender?, dateBirthday: Date?, categoriesPrefered: [String], avatar: String?, levelMaxUnlocked: Int?, levelPercentage: Double?, dochos: Int, experience: Int, perfectPriceCpt: Int?, rank: UInt, badgesUnlockedIdentifiers: [String]?, notifications: Bool, notificationTokens: [String]) {
        self.pseudo = pseudo
        self.lastName = lastName
        self.firstName = firstName
        self.email = email
        self.gender = gender
        self.dateBirthday = dateBirthday
        self.categoriesPrefered = categoriesPrefered
        self.avatarUrl = avatar
        self.levelMaxUnlocked = levelMaxUnlocked
        self.levelPercentage = levelPercentage
        self.dochos = dochos
        self.experience = experience
        self.perfectPriceCpt = perfectPriceCpt!
        self.rank = rank
        self.badgesUnlockedIdentifiers = badgesUnlockedIdentifiers
        self.notifications = notifications
        self.notificationTokens = notificationTokens
    }
    
    func initPropertiesWithResponseObject(_ jsonObject: JSON) {
        
        self.email      = jsonObject[UserDataKey.kEmail].string
        self.pseudo     = jsonObject[UserDataKey.kUsername].string
        self.firstName  = jsonObject[UserDataKey.kFirstName].string
        self.lastName   = jsonObject[UserDataKey.kLastName].string
        self.gender     = jsonObject[UserDataKey.kGender].string.map { Gender(rawValue: $0)! }
        self.avatarUrl  = jsonObject[UserDataKey.kAvatarUrl].string
        
        self.categoriesPrefered = jsonObject[UserDataKey.kCategoryPrefered].arrayObject as! [String]
        
        if let birthdayString = jsonObject[UserDataKey.kDateBirthday].string {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            self.dateBirthday = dateFormatter.date(from: birthdayString)
        }
        
        self.dochos = jsonObject[UserDataKey.kDochos].intValue
        self.experience = jsonObject[UserDataKey.kExperience].intValue
        self.perfectPriceCpt = jsonObject[UserDataKey.kPerfectPriceCpt].intValue
        self.levelMaxUnlocked = jsonObject[UserDataKey.kLevelMaxUnlocked].int
        self.levelPercentage = jsonObject[UserDataKey.kLevelPercentage].double
        self.notifications = jsonObject[UserDataKey.kNotifications].boolValue
        self.notificationTokens = jsonObject[UserDataKey.kNotificationTokens].arrayObject as! [String]
        self.experience = jsonObject[UserDataKey.kExperience].intValue
        self.rank = jsonObject[UserDataKey.kRank].uIntValue
    }
    
    func initPropertiesFromUser(user: User) {
        let user = user
        if let email = user.email { self.email = email }
        if let pseudo = user.pseudo { self.pseudo = pseudo }
        if let firstName = user.firstName { self.firstName = firstName }
        if let lastName = user.lastName { self.lastName = lastName }
        if let gender = user.gender { self.gender = gender }
        if let dateBirthday = user.dateBirthday { self.dateBirthday = dateBirthday }
        if let avatarUrl = user.avatarUrl { self.avatarUrl = avatarUrl }
        self.categoriesPrefered = user.categoriesPrefered
        self.dochos = user.dochos
        self.experience = user.experience
        if let level = user.levelMaxUnlocked { self.levelMaxUnlocked = level }
        if let levelPercentage = user.levelPercentage { self.levelPercentage = levelPercentage }
        self.perfectPriceCpt = user.perfectPriceCpt
        self.rank = user.rank
        self.notifications = user.notifications
        self.notificationTokens = user.notificationTokens
    }
    
    func getGenderDataForDisplay() -> String? {
        if let gender = self.gender {
            switch gender {
                case .male:         return "Homme"
                case .female:       return "Femme"
                case .universal:    return "Autre"
            }
        }
        
        return nil
    }
}
