//
//  UserSessionFacebook.swift
//  Docha
//
//  Created by Mathis D on 29/05/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

class UserSessionFacebook: UserSession {
    
    var facebookID: String?
    var facebookAccessToken: String?
    var facebookImageURL: String?
    
    override init() {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        let facebookID = aDecoder.decodeObjectForKey(Constants.UserDefaultsKey.kUserInfosFacebookID) as? String
        let facebookAccessToken = aDecoder.decodeObjectForKey(Constants.UserDefaultsKey.kUserInfosFacebookAccessToken) as? String
        let facebookImageURL = aDecoder.decodeObjectForKey(Constants.UserDefaultsKey.kUserInfosFacebookImageURL) as? String
        
        super.init(coder: aDecoder)
        
        self.facebookID = facebookID
        self.facebookAccessToken = facebookAccessToken
        self.facebookImageURL = facebookImageURL
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(self.facebookID, forKey: Constants.UserDefaultsKey.kUserInfosFacebookID)
        aCoder.encodeObject(self.facebookAccessToken, forKey: Constants.UserDefaultsKey.kUserInfosFacebookAccessToken)
        aCoder.encodeObject(self.facebookImageURL, forKey: Constants.UserDefaultsKey.kUserInfosFacebookImageURL)
    }
    
    override func generateJSONFromUserSession() -> [String : AnyObject]? {
        var dataUser = super.generateJSONFromUserSession()
        if let facebookID = self.facebookID { dataUser![UserDataKey.kFacebookID] = facebookID }
        if let facebookAccessToken = self.facebookAccessToken { dataUser![UserDataKey.kFacebookToken] = facebookAccessToken }
        if let facebookImageURL = self.facebookImageURL { dataUser![UserDataKey.kFacebookImageURL] = facebookImageURL }
        
        return dataUser
    }
}