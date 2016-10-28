//
//  UserSession.swift
//  DochaProto
//
//  Created by Mathis D on 20/05/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserSession: User, NSCoding {
    var authToken: String?
    
    override init() {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        let pseudo = aDecoder.decodeObject(forKey: Constants.UserDefaultsKey.kUserInfosPseudo) as? String
        let lastName = aDecoder.decodeObject(forKey: Constants.UserDefaultsKey.kUserInfosLastName) as? String
        let firstName = aDecoder.decodeObject(forKey: Constants.UserDefaultsKey.kUserInfosFirstName) as? String
        let email = aDecoder.decodeObject(forKey: Constants.UserDefaultsKey.kUserInfosEmail) as? String
        let gender = aDecoder.decodeObject(forKey: Constants.UserDefaultsKey.kUserInfosGender) as? String
        let dateBirthday = aDecoder.decodeObject(forKey: Constants.UserDefaultsKey.kUserInfosDateBirthday) as? Date
        let categoriesPrefered = aDecoder.decodeObject(forKey: Constants.UserDefaultsKey.kUserInfosCategoryPrefered) as? [String]
        let avatar = aDecoder.decodeObject(forKey: Constants.UserDefaultsKey.kUserInfosAvatarUrl) as? String
        let levelMaxUnlocked = aDecoder.decodeInteger(forKey: Constants.UserDefaultsKey.kUserInfosLevelMaxUnlocked) as Int
        let levelPercentage = aDecoder.decodeDouble(forKey: Constants.UserDefaultsKey.kUserInfosLevelPercentage) as Double
        let dochos = aDecoder.decodeInteger(forKey: Constants.UserDefaultsKey.kUserInfosDochos) as Int
        let experience = aDecoder.decodeInteger(forKey: Constants.UserDefaultsKey.kUserInfosExperience) as Int
        let perfectPriceCpt = aDecoder.decodeInteger(forKey: Constants.UserDefaultsKey.kUserInfosPerfectPriceCpt) as Int
        let rank = aDecoder.decodeInteger(forKey: Constants.UserDefaultsKey.kUserInfosRank) as Int
        let authToken = aDecoder.decodeObject(forKey: Constants.UserDefaultsKey.kUserInfosAuthToken) as? String
        let badgesUnlockedIdentifiers = aDecoder.decodeObject(forKey: Constants.UserDefaultsKey.kUserInfosBadgesUnlockedIdentifiers) as? [String]
        let notifications = aDecoder.decodeBool(forKey: Constants.UserDefaultsKey.kUserInfosNotifications) as Bool
        let notificationTokens = aDecoder.decodeObject(forKey: Constants.UserDefaultsKey.kuserInfosNotificationTokens) as? [String]
        
        super.init(pseudo: pseudo, lastName: lastName, firstName: firstName, email: email, gender: Gender(rawValue: gender!), dateBirthday: dateBirthday, categoriesPrefered: categoriesPrefered ?? [], avatar: avatar, levelMaxUnlocked: levelMaxUnlocked, levelPercentage: levelPercentage, dochos: dochos, experience: experience, perfectPriceCpt: perfectPriceCpt, rank: UInt(rank), badgesUnlockedIdentifiers: badgesUnlockedIdentifiers, notifications: notifications, notificationTokens: notificationTokens ?? [])
        
        self.authToken = authToken
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(pseudo, forKey: Constants.UserDefaultsKey.kUserInfosPseudo)
        aCoder.encode(lastName, forKey: Constants.UserDefaultsKey.kUserInfosLastName)
        aCoder.encode(firstName, forKey: Constants.UserDefaultsKey.kUserInfosFirstName)
        aCoder.encode(email, forKey: Constants.UserDefaultsKey.kUserInfosEmail)
        aCoder.encode(gender?.rawValue, forKey: Constants.UserDefaultsKey.kUserInfosGender)
        aCoder.encode(dateBirthday, forKey: Constants.UserDefaultsKey.kUserInfosDateBirthday)
        aCoder.encode(categoriesPrefered, forKey: Constants.UserDefaultsKey.kUserInfosCategoryPrefered)
        aCoder.encode(levelMaxUnlocked!, forKey: Constants.UserDefaultsKey.kUserInfosLevelMaxUnlocked)
        aCoder.encode(levelPercentage!, forKey: Constants.UserDefaultsKey.kUserInfosLevelPercentage)
        aCoder.encode(dochos, forKey: Constants.UserDefaultsKey.kUserInfosDochos)
        aCoder.encode(experience, forKey: Constants.UserDefaultsKey.kUserInfosExperience)
        aCoder.encode(perfectPriceCpt, forKey: Constants.UserDefaultsKey.kUserInfosPerfectPriceCpt)
        aCoder.encode(Int(rank), forKey: Constants.UserDefaultsKey.kUserInfosRank)
        aCoder.encode(avatarUrl, forKey: Constants.UserDefaultsKey.kUserInfosAvatarUrl)
        aCoder.encode(authToken, forKey: Constants.UserDefaultsKey.kUserInfosAuthToken)
        aCoder.encode(badgesUnlockedIdentifiers, forKey: Constants.UserDefaultsKey.kUserInfosBadgesUnlockedIdentifiers)
        aCoder.encode(notifications, forKey: Constants.UserDefaultsKey.kUserInfosNotifications)
        aCoder.encode(notificationTokens, forKey: Constants.UserDefaultsKey.kuserInfosNotificationTokens)
    }
    
    func saveSession() {
        let userDefaults = UserDefaults.standard
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: self)
        userDefaults.set(encodedData, forKey: Constants.UserDefaultsKey.kUserSessionObject)
        userDefaults.synchronize()
    }
    
    func deleteSession() {
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaultsKey.kUserSessionObject)
        UserDefaults.standard.synchronize()
    }
    
    func saveUserAvatarImage(_ image: UIImage) {
        let imageData = UIImageJPEGRepresentation(image, 1)
        let relativePath = "image_\(Date.timeIntervalSinceReferenceDate).png"
        let path = documentsPathForFileName(relativePath)
        try? imageData?.write(to: URL(fileURLWithPath: path), options: [.atomic])
        UserDefaults.standard.set(relativePath, forKey: Constants.UserDefaultsKey.kUserInfosAvatarImage)
        UserDefaults.standard.synchronize()
    }
    
    func deleteUserAvatarImage() {
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaultsKey.kUserInfosAvatarImage)
        UserDefaults.standard.synchronize()
    }
    
    func documentsPathForFileName(_ name: String) -> String {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = URL(fileURLWithPath: path)
        let filePath = url.appendingPathComponent(name).path
        return filePath
    }
    
    override func initPropertiesFromUser(user: User) {
        super.initPropertiesFromUser(user: user)
    }
    
    override func initPropertiesWithResponseObject(_ jsonObject: JSON) {
        super.initPropertiesWithResponseObject(jsonObject)
        authToken = jsonObject[UserDataKey.kAuthToken].string
    }
    
    func generateJSONFromUserSession() -> [String:AnyObject]? {
        var dataUser = [String:AnyObject]()
        
        if let pseudo = self.pseudo { dataUser[UserDataKey.kUsername] = pseudo as AnyObject? }
        if let lastName = self.lastName { dataUser[UserDataKey.kLastName] = lastName as AnyObject? }
        if let firstName = self.firstName { dataUser[UserDataKey.kFirstName] = firstName as AnyObject? }
        if let email = self.email { dataUser[UserDataKey.kEmail] = email as AnyObject? }
        
        if let gender = self.gender { dataUser[UserDataKey.kGender] = gender.rawValue as AnyObject? }
        if let dateBirthday = self.dateBirthday {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMMM yyyy"
            dataUser[UserDataKey.kDateBirthday] = dateFormatter.string(from: dateBirthday as Date) as AnyObject?
        }
        
        dataUser[UserDataKey.kCategoryPrefered] = categoriesPrefered as AnyObject?
        if let avatarUrl = self.avatarUrl { dataUser[UserDataKey.kAvatarUrl] = avatarUrl as AnyObject? }
        if let authToken = self.authToken { dataUser[UserDataKey.kAuthToken] = authToken as AnyObject? }
        dataUser[UserDataKey.kDochos] = dochos as AnyObject?
        dataUser[UserDataKey.kExperience] = experience as AnyObject?
        dataUser[UserDataKey.kLevelMaxUnlocked] = levelMaxUnlocked as AnyObject?
        dataUser[UserDataKey.kLevelPercentage] = levelPercentage as AnyObject?
        dataUser[UserDataKey.kPerfectPriceCpt] = perfectPriceCpt as AnyObject?
        dataUser[UserDataKey.kRank] = rank as AnyObject?
        dataUser[UserDataKey.kNotifications] = notifications as AnyObject?
        dataUser[UserDataKey.kNotificationTokens] = notificationTokens as AnyObject?
        
        return dataUser
    }
}
