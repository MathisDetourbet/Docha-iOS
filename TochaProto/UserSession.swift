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
    var productsIDPlayed: [Int]?
    
    override init() {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        let userID = aDecoder.decodeObjectForKey(Constants.UserDefaultsKey.kUserInfosUserID) as? Int
        let pseudo = aDecoder.decodeObjectForKey(Constants.UserDefaultsKey.kUserInfosPseudo) as? String
        let lastName = aDecoder.decodeObjectForKey(Constants.UserDefaultsKey.kUserInfosLastName) as? String
        let firstName = aDecoder.decodeObjectForKey(Constants.UserDefaultsKey.kUserInfosFirstName) as? String
        let email = aDecoder.decodeObjectForKey(Constants.UserDefaultsKey.kUserInfosEmail) as? String
        let gender = aDecoder.decodeObjectForKey(Constants.UserDefaultsKey.kUserInfosGender) as? String
        let dateBirthday = aDecoder.decodeObjectForKey(Constants.UserDefaultsKey.kUserInfosDateBirthday) as? NSDate
        let categoriesFavorites = aDecoder.decodeObjectForKey(Constants.UserDefaultsKey.kUserInfosCategoryFavorite) as? [String]
        let avatar = aDecoder.decodeObjectForKey(Constants.UserDefaultsKey.kUserInfosAvatar) as? String
        let levelMaxUnlocked = aDecoder.decodeIntegerForKey(Constants.UserDefaultsKey.kUserInfosLevelMaxUnlocked) as Int
        let dochos = aDecoder.decodeIntegerForKey(Constants.UserDefaultsKey.kUserInfosDochos) as Int
        let experience = aDecoder.decodeIntegerForKey(Constants.UserDefaultsKey.kUserInfosExperience) as Int
        let perfectPriceCpt = aDecoder.decodeIntegerForKey(Constants.UserDefaultsKey.kUserInfosPerfectPriceCpt) as Int
        let authToken = aDecoder.decodeObjectForKey(Constants.UserDefaultsKey.kUserInfosAuthToken) as? String
        let sessionID = aDecoder.decodeIntegerForKey(Constants.UserDefaultsKey.kUserInfosSessionID) as Int
        let productsIDPlayed = aDecoder.decodeObjectForKey(Constants.UserDefaultsKey.kProductsIDPlayed) as? [Int]
        //let profilImagePrefered = ProfilImageType(rawValue: (aDecoder.decodeIntegerForKey(Constants.UserDefaultsKey.kProfilImagePrefered)))
        let badgesUnlockedIdentifiers = aDecoder.decodeObjectForKey(Constants.UserDefaultsKey.kUserInfosBadgesUnlockedIdentifiers) as? [String]
        
        super.init(userID: userID, pseudo: pseudo, lastName: lastName, firstName: firstName, email: email, gender: gender, dateBirthday: dateBirthday, categoriesFavorites: categoriesFavorites, avatar: avatar, levelMaxUnlocked: levelMaxUnlocked, dochos: dochos, experience: experience, perfectPriceCpt: perfectPriceCpt, badgesUnlockedIdentifiers: badgesUnlockedIdentifiers)
        
        self.authToken = authToken
        self.sessionID = sessionID
        self.productsIDPlayed = productsIDPlayed
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(userID, forKey: Constants.UserDefaultsKey.kUserInfosUserID)
        aCoder.encodeObject(pseudo, forKey: Constants.UserDefaultsKey.kUserInfosPseudo)
        aCoder.encodeObject(lastName, forKey: Constants.UserDefaultsKey.kUserInfosLastName)
        aCoder.encodeObject(firstName, forKey: Constants.UserDefaultsKey.kUserInfosFirstName)
        aCoder.encodeObject(email, forKey: Constants.UserDefaultsKey.kUserInfosEmail)
        aCoder.encodeObject(gender, forKey: Constants.UserDefaultsKey.kUserInfosGender)
        aCoder.encodeObject(dateBirthday, forKey: Constants.UserDefaultsKey.kUserInfosDateBirthday)
        aCoder.encodeObject(categoriesFavorites, forKey: Constants.UserDefaultsKey.kUserInfosCategoryFavorite)
        aCoder.encodeInteger(levelMaxUnlocked, forKey: Constants.UserDefaultsKey.kUserInfosLevelMaxUnlocked)
        aCoder.encodeInteger(dochos, forKey: Constants.UserDefaultsKey.kUserInfosDochos)
        aCoder.encodeInteger(experience, forKey: Constants.UserDefaultsKey.kUserInfosExperience)
        aCoder.encodeInteger(perfectPriceCpt, forKey: Constants.UserDefaultsKey.kUserInfosPerfectPriceCpt)
        aCoder.encodeObject(avatar, forKey: Constants.UserDefaultsKey.kUserInfosAvatar)
        aCoder.encodeObject(authToken, forKey: Constants.UserDefaultsKey.kUserInfosAuthToken)
        aCoder.encodeObject(productsIDPlayed, forKey: Constants.UserDefaultsKey.kProductsIDPlayed)
        //aCoder.encodeInteger(profilImagePrefered.rawValue, forKey: Constants.UserDefaultsKey.kProfilImagePrefered)
        aCoder.encodeObject(badgesUnlockedIdentifiers, forKey: Constants.UserDefaultsKey.kUserInfosBadgesUnlockedIdentifiers)
    }
    
    func saveSession() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let encodedData = NSKeyedArchiver.archivedDataWithRootObject(self)
        userDefaults.setObject(encodedData, forKey: Constants.UserDefaultsKey.kUserSessionObject)
        userDefaults.synchronize()
    }
    
    func deleteSession() {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(Constants.UserDefaultsKey.kUserSessionObject)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func getUserProfileImage() -> UIImage? {
//        let imagePath = NSUserDefaults.standardUserDefaults().objectForKey(Constants.UserDefaultsKey.kUserInfosProfileImageFilePath) as? String
//        if let oldImagePath = imagePath {
//            let oldFullPath = self.documentsPathForFileName(oldImagePath)
//            let oldImageData = NSData(contentsOfFile: oldFullPath)
//            let oldImage = UIImage(data: oldImageData!)
//            
//            return oldImage!
//        }
//        
//        return nil
    }
    
    func saveProfileImage(image: UIImage) {
        let imageData = UIImageJPEGRepresentation(image, 1)
        let relativePath = "image_\(NSDate.timeIntervalSinceReferenceDate()).jpg"
        let path = self.documentsPathForFileName(relativePath)
        imageData?.writeToFile(path, atomically: true)
        NSUserDefaults.standardUserDefaults().setObject(relativePath, forKey: Constants.UserDefaultsKey.kUserInfosProfileImageFilePath)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func deleteProfilImage() {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(Constants.UserDefaultsKey.kUserInfosProfileImageFilePath)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
//    func updateProfilImagePrefered(profilImageType: ProfilImageType) {
//        self.profilImagePrefered = profilImageType
//        self.saveSession()
//    }
    
    func documentsPathForFileName(name: String) -> String {
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        let filePath = url.URLByAppendingPathComponent(name).path!
        return filePath
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
        if let pseudo = self.pseudo { dataUser[UserDataKey.kPseudo] = pseudo }
        if let lastName = self.lastName { dataUser[UserDataKey.kLastName] = lastName }
        if let firstName = self.firstName { dataUser[UserDataKey.kFirstName] = firstName }
        if let email = self.email { dataUser[UserDataKey.kEmail] = email }
        
        if let gender = self.gender { dataUser[UserDataKey.kGender] = gender }
        if let dateBirthday = self.dateBirthday {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd MMMM yyyy"
            dataUser[UserDataKey.kDateBirthday] = dateFormatter.stringFromDate(dateBirthday)
        }
        if let categoriesFavorites = self.categoriesFavorites { dataUser[UserDataKey.kCategoryFavorite] = categoriesFavorites }
        if let avatar = self.avatar { dataUser[UserDataKey.kAvatar] = avatar }
        if let authToken = self.authToken { dataUser[UserDataKey.kAuthToken] = authToken }
        if let sessionID = self.sessionID { dataUser[UserDataKey.kSessionID] = sessionID }
        dataUser[UserDataKey.kDochos] = dochos
        dataUser[UserDataKey.kExperience] = experience
        dataUser[UserDataKey.kLevelMaxUnlocked] = levelMaxUnlocked
        dataUser[UserDataKey.kPerfectPriceCpt] = perfectPriceCpt
        
        return dataUser
    }
}
