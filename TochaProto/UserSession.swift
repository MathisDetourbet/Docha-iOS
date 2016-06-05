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
    var sessionID: Int?
    
    override init() {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        let userID = aDecoder.decodeObjectForKey(Constants.UserDefaultsKey.kUserInfosUserID) as? Int
        let username = aDecoder.decodeObjectForKey(Constants.UserDefaultsKey.kUserInfosUsername) as? String
        let lastName = aDecoder.decodeObjectForKey(Constants.UserDefaultsKey.kUserInfosLastName) as? String
        let firstName = aDecoder.decodeObjectForKey(Constants.UserDefaultsKey.kUserInfosFirstName) as? String
        let email = aDecoder.decodeObjectForKey(Constants.UserDefaultsKey.kUserInfosEmail) as? String
        let gender = aDecoder.decodeObjectForKey(Constants.UserDefaultsKey.kUserInfosGender) as? String
        let dateBirthday = aDecoder.decodeObjectForKey(Constants.UserDefaultsKey.kUserInfosDateBirthday) as? NSDate
        let categoryFavorite = aDecoder.decodeObjectForKey(Constants.UserDefaultsKey.kUserInfosCategoryFavorite) as? String
        let avatar = aDecoder.decodeObjectForKey(Constants.UserDefaultsKey.kUserInfosAvatar) as? String
        let levelMaxUnlocked = aDecoder.decodeIntegerForKey(Constants.UserDefaultsKey.kUserInfosLevelMaxUnlocked) as Int
        let dochos = aDecoder.decodeIntegerForKey(Constants.UserDefaultsKey.kUserInfosDochos) as Int
        let experience = aDecoder.decodeIntegerForKey(Constants.UserDefaultsKey.kUserInfosExperience) as Int
        let authToken = aDecoder.decodeObjectForKey(Constants.UserDefaultsKey.kUserInfosAuthToken) as? String
        let sessionID = aDecoder.decodeIntegerForKey(Constants.UserDefaultsKey.kUserInfosSessionID) as Int
        
        super.init(userID: userID, username: username, lastName: lastName, firstName: firstName, email: email, gender: gender, dateBirthday: dateBirthday, categoryFavorite: categoryFavorite, avatar: avatar, levelMaxUnlocked: levelMaxUnlocked, dochos: dochos, experience: experience)
        
        self.authToken = authToken
        self.sessionID = sessionID
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(userID, forKey: Constants.UserDefaultsKey.kUserInfosUserID)
        aCoder.encodeObject(username, forKey: Constants.UserDefaultsKey.kUserInfosUsername)
        aCoder.encodeObject(lastName, forKey: Constants.UserDefaultsKey.kUserInfosLastName)
        aCoder.encodeObject(firstName, forKey: Constants.UserDefaultsKey.kUserInfosFirstName)
        aCoder.encodeObject(email, forKey: Constants.UserDefaultsKey.kUserInfosEmail)
        aCoder.encodeObject(gender, forKey: Constants.UserDefaultsKey.kUserInfosGender)
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
    
    override func initPropertiesWithResponseObject(responseObject: AnyObject) {
        super.initPropertiesWithResponseObject(responseObject)
        if let dicoUser = responseObject["user"] as? [String: AnyObject] {
            if let authToken = dicoUser["auth_token"]?.string { self.authToken = authToken }
            if let sessionID = dicoUser["session_id"]?.integerValue { self.sessionID = sessionID }
        }
    }
    
    func generateJSONFromUserSession() -> [String:AnyObject]? {
        var dataUser = [String:AnyObject]()
        
        if let userID = self.userID { dataUser[UserDataKey.kUserID] = userID }
        if let username = self.username { dataUser[UserDataKey.kUsername] = username }
        if let lastName = self.lastName { dataUser[UserDataKey.kLastName] = lastName }
        if let firstName = self.firstName { dataUser[UserDataKey.kFirstName] = firstName }
        if let email = self.email { dataUser[UserDataKey.kEmail] = email }
        if let gender = self.gender { dataUser[UserDataKey.kGender] = gender }
        if let dateBirthday = self.dateBirthday { dataUser[UserDataKey.kDateBirthday] = dateBirthday }
        if let categoryFavorite = self.categoryFavorite { dataUser[UserDataKey.kCategoryFavorite] = categoryFavorite }
        if let avatar = self.avatar { dataUser[UserDataKey.kAvatar] = avatar }
        if let authToken = self.authToken { dataUser[UserDataKey.kAuthToken] = authToken }
        if let sessionID = self.sessionID { dataUser[UserDataKey.kSessionID] = sessionID }
        dataUser[UserDataKey.kDochos] = dochos
        dataUser[UserDataKey.kExperience] = experience
        
        return dataUser
    }
}
