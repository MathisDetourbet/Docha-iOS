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
    
    override init() {
        super.init()
    }
    
    convenience required init(coder aDecoder: NSCoder) {
        self.init()
        self.facebookID = aDecoder.decodeObjectForKey(Constants.UserDefaultsKey.kUserInfosFacebookID) as? String
        self.facebookAccessToken = aDecoder.decodeObjectForKey(Constants.UserDefaultsKey.kUserInfosFacebookAccessToken) as? String
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(self.facebookID, forKey: Constants.UserDefaultsKey.kUserInfosFacebookID)
        aCoder.encodeObject(self.facebookAccessToken, forKey: Constants.UserDefaultsKey.kUserInfosFacebookAccessToken)
    }
}