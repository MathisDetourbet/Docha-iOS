//
//  UserSessionGooglePlus.swift
//  Docha
//
//  Created by Mathis D on 29/05/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

class UserSessionGooglePlus: UserSession {
    
    var googlePlusID: String?
    var googlePlusAccessToken: String?
    
    override init() {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        let googlePlusID = aDecoder.decodeObject(forKey: Constants.UserDefaultsKey.kUserInfosGooglePlusID) as? String
        let googlePlusAccessToken = aDecoder.decodeObject(forKey: Constants.UserDefaultsKey.kUserInfosGooglePlusAccessToken) as? String
        
        super.init(coder: aDecoder)
        
        self.googlePlusID = googlePlusID
        self.googlePlusAccessToken = googlePlusAccessToken
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(self.googlePlusID, forKey: Constants.UserDefaultsKey.kUserInfosGooglePlusID)
        aCoder.encode(self.googlePlusAccessToken, forKey: Constants.UserDefaultsKey.kUserInfosGooglePlusAccessToken)
    }
    
    override func generateJSONFromUserSession() -> [String : AnyObject]? {
        var dataUser = super.generateJSONFromUserSession()
        if let googlePlusID = self.googlePlusID { dataUser![UserDataKey.kGooglePlusID] = googlePlusID as AnyObject? }
        if let googlePlusAccessToken = self.googlePlusAccessToken { dataUser![UserDataKey.kGooglePlusToken] = googlePlusAccessToken as AnyObject? }
        
        return dataUser
    }
}
