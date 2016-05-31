//
//  UserSessionEmail.swift
//  Docha
//
//  Created by Mathis D on 29/05/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

class UserSessionEmail: UserSession {
    var password: String?
    
    override init() {
        super.init()
    }
    
    convenience required init(coder aDecoder: NSCoder) {
        self.init()
        self.password = aDecoder.decodeObjectForKey(Constants.UserDefaultsKey.kUserInfosPassword) as? String
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(self.password, forKey: Constants.UserDefaultsKey.kUserInfosPassword)
    }
}