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
    
    
    required convenience init(coder aDecoder: NSCoder) {
        super.init(coder)
        self.lastName = aDecoder.decodeObjectForKey(Constants.UserDefaultsKey.kUserInfosLastName) as? String
        self.firstName = aDecoder.decodeObjectForKey(Constants.UserDefaultsKey.kUserInfosFirstName) as? String
        self.email = aDecoder.decodeObjectForKey(Constants.UserDefaultsKey.kUserInfosEmail) as? String
        self.sexe = aDecoder.decodeObjectForKey(Constants.UserDefaultsKey.kUserInfosSexe) as? String
        self.dateBirthday = aDecoder.decodeObjectForKey(Constants.UserDefaultsKey.kUserInfosDateBirthday) as? NSDate
        self.categoryFavorite = aDecoder.decodeObjectForKey(Constants.UserDefaultsKey.kUserInfosCategoryFavorite) as? String
        self.levelMaxUnlocked = aDecoder.decodeIntegerForKey(Constants.UserDefaultsKey.kUserInfosLevelMaxUnlocked)
        self.dochos = aDecoder.decodeIntegerForKey(Constants.UserDefaultsKey.kUserInfosDochos)
        self.experience = aDecoder.decodeIntegerForKey(Constants.UserDefaultsKey.kUserInfosExperience)
        //init(levelMaxUnlocked: levelMaxUnlocked, dochos: dochos, experience: experience)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(levelMaxUnlocked, forKey: Constants.UserDefaultsKey.kUserInfosLevelMaxUnlocked)
        aCoder.encodeInteger(dochos, forKey: Constants.UserDefaultsKey.kUserInfosDochos)
        aCoder.encodeInteger(experience, forKey: Constants.UserDefaultsKey.kUserInfosExperience)
    }
}
