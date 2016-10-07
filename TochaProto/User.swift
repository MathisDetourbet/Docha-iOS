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
    var gender: String?
    var dateBirthday: Date?
    var categoriesPrefered: [String] = []
    var avatarUrl: String?
    var levelMaxUnlocked: Int = 1
    var dochos: Int = 0
    var experience: Int = 0
    var perfectPriceCpt: Int = 0
    var badgesUnlockedIdentifiers: [String]?
    
    override init() {}
    
    init(pseudo: String?, lastName: String?, firstName: String?, email: String?, gender: String?, dateBirthday: Date?, categoriesPrefered: [String]?, avatar: String?, levelMaxUnlocked: Int?, dochos: Int?, experience: Int?, perfectPriceCpt: Int?, badgesUnlockedIdentifiers: [String]?) {
        self.pseudo = pseudo
        self.lastName = lastName
        self.firstName = firstName
        self.email = email
        self.gender = gender
        self.dateBirthday = dateBirthday
        self.categoriesPrefered = categoriesPrefered!
        self.avatarUrl = avatar
        self.levelMaxUnlocked = levelMaxUnlocked!
        self.dochos = dochos!
        self.experience = experience!
        self.perfectPriceCpt = perfectPriceCpt!
        self.badgesUnlockedIdentifiers = badgesUnlockedIdentifiers
    }
    
    func initPropertiesWithResponseObject(_ jsonObject: JSON) {
        
        self.email      = jsonObject[UserDataKey.kEmail].string
        self.pseudo     = jsonObject[UserDataKey.kUsername].string
        self.firstName  = jsonObject[UserDataKey.kFirstName].string
        self.lastName   = jsonObject[UserDataKey.kLastName].string
        self.gender     = jsonObject[UserDataKey.kGender].string
        self.avatarUrl  = jsonObject[UserDataKey.kAvatarUrl].string
        
        self.categoriesPrefered = jsonObject[UserDataKey.kCategoryPrefered].arrayObject as! [String]
        
        if let birthdayString = jsonObject[UserDataKey.kDateBirthday].string {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            self.dateBirthday = dateFormatter.date(from: birthdayString)
        }
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
        if user.categoriesPrefered.isEmpty == false { self.categoriesPrefered = user.categoriesPrefered }
    }
    
    func getGenderDataForDisplay() -> String? {
        if let gender = self.gender {
            switch gender {
                case "male":    return "Homme"
                case "female":  return "Femme"
                default:        return "Autre"
            }
        }
        
        return nil
    }
}
