//
//  User.swift
//  DochaProto
//
//  Created by Mathis D on 17/03/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

class User: NSObject, NSCoding {
//    var lastName: String?
//    var firstName: String?
//    var email: String?
//    var sexe: String?
//    var age: Int?
//    var dateBirthday: NSDate?
//    var city: String?
//    var hobbies: [String?] = []
    
    var levelMaxUnlocked: Int = 1
    var dochos: Int = 0
    var experience: Int = 0
    var authToken: String = ""
    
    convenience override init() {
        self.init(levelMaxUnlocked: 1, dochos: 0, experience: 0, authToken: "")
    }
    
    init(levelMaxUnlocked: Int, dochos: Int, experience: Int, authToken: String) {
        self.levelMaxUnlocked = levelMaxUnlocked
        self.dochos = dochos
        self.experience = experience
        self.authToken = authToken
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let levelMaxUnlocked = aDecoder.decodeIntegerForKey(Constants.UserDefaultsKey.kUserInfosLevelMaxUnlocked)
        let dochos = aDecoder.decodeIntegerForKey(Constants.UserDefaultsKey.kUserInfosDochos)
        let experience = aDecoder.decodeIntegerForKey(Constants.UserDefaultsKey.kUserInfosExperience)
        let authToken = aDecoder.decodeObjectForKey(Constants.UserAuthentificationKey.kUserAuthentificationToken) as! String
        self.init(levelMaxUnlocked: levelMaxUnlocked, dochos: dochos, experience: experience, authToken: authToken)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(levelMaxUnlocked, forKey: Constants.UserDefaultsKey.kUserInfosLevelMaxUnlocked)
        aCoder.encodeInteger(dochos, forKey: Constants.UserDefaultsKey.kUserInfosDochos)
        aCoder.encodeInteger(experience, forKey: Constants.UserDefaultsKey.kUserInfosExperience)
        aCoder.encodeObject(authToken, forKey: Constants.UserAuthentificationKey.kUserAuthentificationToken)
    }
}
