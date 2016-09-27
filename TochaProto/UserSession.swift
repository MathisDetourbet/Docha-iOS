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
        let userID = aDecoder.decodeObject(forKey: Constants.UserDefaultsKey.kUserInfosUserID) as? Int
        let pseudo = aDecoder.decodeObject(forKey: Constants.UserDefaultsKey.kUserInfosPseudo) as? String
        let lastName = aDecoder.decodeObject(forKey: Constants.UserDefaultsKey.kUserInfosLastName) as? String
        let firstName = aDecoder.decodeObject(forKey: Constants.UserDefaultsKey.kUserInfosFirstName) as? String
        let email = aDecoder.decodeObject(forKey: Constants.UserDefaultsKey.kUserInfosEmail) as? String
        let gender = aDecoder.decodeObject(forKey: Constants.UserDefaultsKey.kUserInfosGender) as? String
        let dateBirthday = aDecoder.decodeObject(forKey: Constants.UserDefaultsKey.kUserInfosDateBirthday) as? Date
        let categoriesFavorites = aDecoder.decodeObject(forKey: Constants.UserDefaultsKey.kUserInfosCategoryFavorite) as? [String]
        let avatar = aDecoder.decodeObject(forKey: Constants.UserDefaultsKey.kUserInfosAvatar) as? String
        let levelMaxUnlocked = aDecoder.decodeInteger(forKey: Constants.UserDefaultsKey.kUserInfosLevelMaxUnlocked) as Int
        let dochos = aDecoder.decodeInteger(forKey: Constants.UserDefaultsKey.kUserInfosDochos) as Int
        let experience = aDecoder.decodeInteger(forKey: Constants.UserDefaultsKey.kUserInfosExperience) as Int
        let perfectPriceCpt = aDecoder.decodeInteger(forKey: Constants.UserDefaultsKey.kUserInfosPerfectPriceCpt) as Int
        let authToken = aDecoder.decodeObject(forKey: Constants.UserDefaultsKey.kUserInfosAuthToken) as? String
        let sessionID = aDecoder.decodeInteger(forKey: Constants.UserDefaultsKey.kUserInfosSessionID) as Int
        let productsIDPlayed = aDecoder.decodeObject(forKey: Constants.UserDefaultsKey.kProductsIDPlayed) as? [Int]
        //let profilImagePrefered = ProfilImageType(rawValue: (aDecoder.decodeIntegerForKey(Constants.UserDefaultsKey.kProfilImagePrefered)))
        let badgesUnlockedIdentifiers = aDecoder.decodeObject(forKey: Constants.UserDefaultsKey.kUserInfosBadgesUnlockedIdentifiers) as? [String]
        
        super.init(userID: userID, pseudo: pseudo, lastName: lastName, firstName: firstName, email: email, gender: gender, dateBirthday: dateBirthday, categoriesFavorites: categoriesFavorites, avatar: avatar, levelMaxUnlocked: levelMaxUnlocked, dochos: dochos, experience: experience, perfectPriceCpt: perfectPriceCpt, badgesUnlockedIdentifiers: badgesUnlockedIdentifiers)
        
        self.authToken = authToken
        self.sessionID = sessionID
        self.productsIDPlayed = productsIDPlayed
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(userID, forKey: Constants.UserDefaultsKey.kUserInfosUserID)
        aCoder.encode(pseudo, forKey: Constants.UserDefaultsKey.kUserInfosPseudo)
        aCoder.encode(lastName, forKey: Constants.UserDefaultsKey.kUserInfosLastName)
        aCoder.encode(firstName, forKey: Constants.UserDefaultsKey.kUserInfosFirstName)
        aCoder.encode(email, forKey: Constants.UserDefaultsKey.kUserInfosEmail)
        aCoder.encode(gender, forKey: Constants.UserDefaultsKey.kUserInfosGender)
        aCoder.encode(dateBirthday, forKey: Constants.UserDefaultsKey.kUserInfosDateBirthday)
        aCoder.encode(categoriesFavorites, forKey: Constants.UserDefaultsKey.kUserInfosCategoryFavorite)
        aCoder.encode(levelMaxUnlocked, forKey: Constants.UserDefaultsKey.kUserInfosLevelMaxUnlocked)
        aCoder.encode(dochos, forKey: Constants.UserDefaultsKey.kUserInfosDochos)
        aCoder.encode(experience, forKey: Constants.UserDefaultsKey.kUserInfosExperience)
        aCoder.encode(perfectPriceCpt, forKey: Constants.UserDefaultsKey.kUserInfosPerfectPriceCpt)
        aCoder.encode(avatar, forKey: Constants.UserDefaultsKey.kUserInfosAvatar)
        aCoder.encode(authToken, forKey: Constants.UserDefaultsKey.kUserInfosAuthToken)
        aCoder.encode(productsIDPlayed, forKey: Constants.UserDefaultsKey.kProductsIDPlayed)
        //aCoder.encodeInteger(profilImagePrefered.rawValue, forKey: Constants.UserDefaultsKey.kProfilImagePrefered)
        aCoder.encode(badgesUnlockedIdentifiers, forKey: Constants.UserDefaultsKey.kUserInfosBadgesUnlockedIdentifiers)
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
        return nil
    }
    
    func saveProfileImage(_ image: UIImage) {
        let imageData = UIImageJPEGRepresentation(image, 1)
        let relativePath = "image_\(Date.timeIntervalSinceReferenceDate).jpg"
        let path = self.documentsPathForFileName(relativePath)
        try? imageData?.write(to: URL(fileURLWithPath: path), options: [.atomic])
        UserDefaults.standard.set(relativePath, forKey: Constants.UserDefaultsKey.kUserInfosProfileImageFilePath)
        UserDefaults.standard.synchronize()
    }
    
    func deleteProfilImage() {
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaultsKey.kUserInfosProfileImageFilePath)
        UserDefaults.standard.synchronize()
    }
    
//    func updateProfilImagePrefered(profilImageType: ProfilImageType) {
//        self.profilImagePrefered = profilImageType
//        self.saveSession()
//    }
    
    func documentsPathForFileName(_ name: String) -> String {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = URL(fileURLWithPath: path)
        let filePath = url.appendingPathComponent(name).path
        return filePath
    }
    
    override func initPropertiesWithResponseObject(_ responseObject: AnyObject) {
        super.initPropertiesWithResponseObject(responseObject)
        if let dicoUser = responseObject["user"] as? [String: AnyObject] {
            if let authToken = dicoUser["auth_token"]?.string { self.authToken = authToken }
            if let sessionID = dicoUser["session_id"]?.intValue { self.sessionID = sessionID }
        }
    }
    
    func generateJSONFromUserSession() -> [String:AnyObject]? {
        var dataUser = [String:AnyObject]()
        
        if let userID = self.userID { dataUser[UserDataKey.kUserID] = userID as AnyObject? }
        if let pseudo = self.pseudo { dataUser[UserDataKey.kPseudo] = pseudo as AnyObject? }
        if let lastName = self.lastName { dataUser[UserDataKey.kLastName] = lastName as AnyObject? }
        if let firstName = self.firstName { dataUser[UserDataKey.kFirstName] = firstName as AnyObject? }
        if let email = self.email { dataUser[UserDataKey.kEmail] = email as AnyObject? }
        
        if let gender = self.gender { dataUser[UserDataKey.kGender] = gender as AnyObject? }
        if let dateBirthday = self.dateBirthday {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMMM yyyy"
            dataUser[UserDataKey.kDateBirthday] = dateFormatter.string(from: dateBirthday as Date) as AnyObject?
        }
        if let categoriesFavorites = self.categoriesFavorites { dataUser[UserDataKey.kCategoryFavorite] = categoriesFavorites as AnyObject? }
        if let avatar = self.avatar { dataUser[UserDataKey.kAvatar] = avatar as AnyObject? }
        if let authToken = self.authToken { dataUser[UserDataKey.kAuthToken] = authToken as AnyObject? }
        if let sessionID = self.sessionID { dataUser[UserDataKey.kSessionID] = sessionID as AnyObject? }
        dataUser[UserDataKey.kDochos] = dochos as AnyObject?
        dataUser[UserDataKey.kExperience] = experience as AnyObject?
        dataUser[UserDataKey.kLevelMaxUnlocked] = levelMaxUnlocked as AnyObject?
        dataUser[UserDataKey.kPerfectPriceCpt] = perfectPriceCpt as AnyObject?
        
        return dataUser
    }
}
