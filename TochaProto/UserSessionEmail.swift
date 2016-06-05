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

    required init(coder aDecoder: NSCoder) {
        let password = aDecoder.decodeObjectForKey(Constants.UserDefaultsKey.kUserInfosPassword) as? String
        
        super.init(coder: aDecoder)
        
        self.password = password
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeObject(self.password, forKey: Constants.UserDefaultsKey.kUserInfosPassword)
    }
    
    override func initPropertiesWithResponseObject(responseObject: AnyObject) {
        super.initPropertiesWithResponseObject(responseObject)
        if let dicoUser = responseObject["user"] as? [String: AnyObject] {
            if let password = dicoUser["password"]?.string { self.password = password }
        }
    }
    
    override func generateJSONFromUserSession() -> [String : AnyObject]? {
        var dataUser = super.generateJSONFromUserSession()
        if let password = self.password { dataUser![UserDataKey.kPassword] = password }
        
        return dataUser
    }
}