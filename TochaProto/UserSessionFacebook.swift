//
//  UserSessionFacebook.swift
//  Docha
//
//  Created by Mathis D on 29/05/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation

class UserSessionFacebook: UserSession {
    var facebookAccessToken: String?
    
    override init() {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        let facebookAccessToken = aDecoder.decodeObject(forKey: Constants.UserDefaultsKey.kUserInfosFacebookAccessToken) as? String
        
        super.init(coder: aDecoder)
        self.facebookAccessToken = facebookAccessToken
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(self.facebookAccessToken, forKey: Constants.UserDefaultsKey.kUserInfosFacebookAccessToken)
    }
    
    override func generateJSONFromUserSession() -> [String : AnyObject]? {
        var dataUser = super.generateJSONFromUserSession()
        if let facebookAccessToken = self.facebookAccessToken { dataUser![UserDataKey.kFacebookToken] = facebookAccessToken as AnyObject? }
        
        return dataUser
    }
    
    func getUserAvatarImage() -> UIImage? {
        let imagePath = UserDefaults.standard.object(forKey: Constants.UserDefaultsKey.kUserInfosAvatarImage) as? String
        if let oldImagePath = imagePath {
            let oldFullPath = documentsPathForFileName(oldImagePath)
            let oldImageData = NSData(contentsOfFile: oldFullPath)
            let oldImage = UIImage(data: oldImageData! as Data)
            
            return oldImage!
        }
        
        return nil
    }
}
