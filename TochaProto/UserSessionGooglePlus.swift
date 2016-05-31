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
    
    convenience required init(coder aDecoder: NSCoder) {
        self.init()
        self.googlePlusID = aDecoder.decodeObjectForKey(Constants.UserDefaultsKey.kUserInfosGooglePlusID) as? String
        self.googlePlusAccessToken = aDecoder.decodeObjectForKey(Constants.UserDefaultsKey.kUserInfosGooglePlusAccessToken) as? String
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(self.googlePlusID, forKey: Constants.UserDefaultsKey.kUserInfosGooglePlusID)
        aCoder.encodeObject(self.googlePlusAccessToken, forKey: Constants.UserDefaultsKey.kUserInfosGooglePlusAccessToken)
    }
}