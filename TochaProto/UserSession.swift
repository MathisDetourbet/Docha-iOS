//
//  UserSession.swift
//  DochaProto
//
//  Created by Mathis D on 20/05/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

class UserSession: User, NSCoding {
    var authToken: String?
    var sessionID: String?
    
    required convenience init(coder aDecoder: NSCoder) {
        self.init()
        self.lastName = aDecoder.decodeObjectForKey(Constants.UserDefaultsKey.kUserInfosLastName) as? String
        self.firstName = aDecoder.decodeObjectForKey(Constants.UserDefaultsKey.kUserInfosFirstName) as? String
        self.email = aDecoder.decodeObjectForKey(Constants.UserDefaultsKey.kUserInfosEmail) as? String
        self.sexe = aDecoder.decodeObjectForKey(Constants.UserDefaultsKey.kUserInfosSexe) as? String
        self.dateBirthday = aDecoder.decodeObjectForKey(Constants.UserDefaultsKey.kUserInfosDateBirthday) as? NSDate
        self.categoryFavorite = aDecoder.decodeObjectForKey(Constants.UserDefaultsKey.kUserInfosCategoryFavorite) as? String
        self.levelMaxUnlocked = aDecoder.decodeIntegerForKey(Constants.UserDefaultsKey.kUserInfosLevelMaxUnlocked) as Int
        self.dochos = aDecoder.decodeIntegerForKey(Constants.UserDefaultsKey.kUserInfosDochos) as Int
        self.experience = aDecoder.decodeIntegerForKey(Constants.UserDefaultsKey.kUserInfosExperience) as Int
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(lastName, forKey: Constants.UserDefaultsKey.kUserInfosLastName)
        aCoder.encodeObject(firstName, forKey: Constants.UserDefaultsKey.kUserInfosFirstName)
        aCoder.encodeObject(email, forKey: Constants.UserDefaultsKey.kUserInfosEmail)
        aCoder.encodeObject(sexe, forKey: Constants.UserDefaultsKey.kUserInfosSexe)
        aCoder.encodeObject(dateBirthday, forKey: Constants.UserDefaultsKey.kUserInfosDateBirthday)
        aCoder.encodeObject(categoryFavorite, forKey: Constants.UserDefaultsKey.kUserInfosCategoryFavorite)
        aCoder.encodeInteger(levelMaxUnlocked, forKey: Constants.UserDefaultsKey.kUserInfosLevelMaxUnlocked)
        aCoder.encodeInteger(dochos, forKey: Constants.UserDefaultsKey.kUserInfosDochos)
        aCoder.encodeInteger(experience, forKey: Constants.UserDefaultsKey.kUserInfosExperience)
        aCoder.encodeObject(avatar, forKey: Constants.UserDefaultsKey.kUserInfosAvatar)
    }
    
    func saveSession() {
        // Saving user state
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let encodedData = NSKeyedArchiver.archivedDataWithRootObject(self)
        userDefaults.setObject(encodedData, forKey: Constants.UserDefaultsKey.kUserSessionObject)
        userDefaults.synchronize()
    }
    
//    init?(authToken: String?, sessionID: String?, userObject: AnyObject) {
//        
//        self.authToken = authToken
//        self.sessionID = sessionID
//        
//        if let dicoUser = userObject["user"] as? [String: AnyObject] {
//            guard
//                let lastName = dicoUser["last_name"]?.string,
//                let firstName = dicoUser["first_name"]?.string,
//                let email = dicoUser["email"]?.string,
//                let sexe = dicoUser["sexe"]?.string,
//                let dateBirthday = dicoUser["date_birthday"]?.date,
//                let categoryFavorite = dicoUser["category_favorite"]?.string,
//                let avatar = dicoUser["avatar"]?.string,
//                let levelMaxUnlocked = dicoUser["level_max_unlocked"]?.integerValue,
//                let dochos = dicoUser["dochos"]?.integerValue,
//                let experience = dicoUser["experience"]?.integerValue
//                else { return nil }
//            
//            super.init(lastName: lastName, firstName: firstName, email: email, sexe: sexe, dateBirthday: dateBirthday, categoryFavorite: categoryFavorite, avatar: avatar, levelMaxUnlocked: levelMaxUnlocked, dochos: dochos, experience: experience)
//        }
//    }
    
    // MARK: NSCoding Protocol
    
//    required init?(coder aDecoder: NSCoder) {
//        
//        let levelMaxUnlocked = aDecoder.decodeIntegerForKey(Constants.UserDefaultsKey.kUserInfosLevelMaxUnlocked) as Int
//        let dochos = aDecoder.decodeIntegerForKey(Constants.UserDefaultsKey.kUserInfosDochos) as Int
//        let experience = aDecoder.decodeIntegerForKey(Constants.UserDefaultsKey.kUserInfosExperience) as Int
//        
//        guard
//            let lastName = aDecoder.decodeObjectForKey(Constants.UserDefaultsKey.kUserInfosLastName) as? String,
//            let firstName = aDecoder.decodeObjectForKey(Constants.UserDefaultsKey.kUserInfosFirstName) as? String,
//            let email = aDecoder.decodeObjectForKey(Constants.UserDefaultsKey.kUserInfosEmail) as? String,
//            let sexe = aDecoder.decodeObjectForKey(Constants.UserDefaultsKey.kUserInfosSexe) as? String,
//            let dateBirthday = aDecoder.decodeObjectForKey(Constants.UserDefaultsKey.kUserInfosDateBirthday) as? NSDate,
//            let categoryFavorite = aDecoder.decodeObjectForKey(Constants.UserDefaultsKey.kUserInfosCategoryFavorite) as? String,
//            let avatar = aDecoder.decodeObjectForKey(Constants.UserDefaultsKey.kUserInfosAvatar) as? String
//            else { return nil }
//        
//        //super.init(lastName: lastName, firstName: firstName, email: email, sexe: sexe, dateBirthday: dateBirthday, categoryFavorite: categoryFavorite, avatar: avatar, levelMaxUnlocked: levelMaxUnlocked, dochos: dochos, experience: experience)
//        
//    }
}
