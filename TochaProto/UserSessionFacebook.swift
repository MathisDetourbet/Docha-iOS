//
//  UserSessionFacebook.swift
//  Docha
//
//  Created by Mathis D on 29/05/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
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
        let facebookID = aDecoder.decodeObject(forKey: Constants.UserDefaultsKey.kUserInfosFacebookID) as? String
        let facebookAccessToken = aDecoder.decodeObject(forKey: Constants.UserDefaultsKey.kUserInfosFacebookAccessToken) as? String
        let facebookImageURL = aDecoder.decodeObject(forKey: Constants.UserDefaultsKey.kUserInfosFacebookImageURL) as? String
        
        super.init(coder: aDecoder)
        
        self.facebookID = facebookID
        self.facebookAccessToken = facebookAccessToken
        self.facebookImageURL = facebookImageURL
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(self.facebookID, forKey: Constants.UserDefaultsKey.kUserInfosFacebookID)
        aCoder.encode(self.facebookAccessToken, forKey: Constants.UserDefaultsKey.kUserInfosFacebookAccessToken)
        aCoder.encode(self.facebookImageURL, forKey: Constants.UserDefaultsKey.kUserInfosFacebookImageURL)
    }
    
    override func generateJSONFromUserSession() -> [String : AnyObject]? {
        var dataUser = super.generateJSONFromUserSession()
        if let facebookID = self.facebookID { dataUser![UserDataKey.kFacebookID] = facebookID as AnyObject? }
        if let facebookAccessToken = self.facebookAccessToken { dataUser![UserDataKey.kFacebookToken] = facebookAccessToken as AnyObject? }
        if let facebookImageURL = self.facebookImageURL { dataUser![UserDataKey.kFacebookImageURL] = facebookImageURL as AnyObject? }
        
        return dataUser
    }
}
