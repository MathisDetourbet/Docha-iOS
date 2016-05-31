//
//  Constants.swift
//  DochaProto
//
//  Created by Mathis D on 01/05/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

struct Constants {
    struct UserDefaultsKey {
        // User object key
        static let kUserSessionObject = "userSessionObject"
        
        // User infos keys
        static let kUserInfosLastName = "userInfosLastName"
        static let kUserInfosFirstName = "userInfosFirstName"
        static let kUserInfosEmail = "userInfosEmail"
        static let kUserInfosGender = "userInfosGender"
        static let kUserInfosDateBirthday = "userInfosDateBirthday"
        static let kUserInfosCategoryFavorite = "userInfosCategoryFavorite"
        static let kUserInfosLevelMaxUnlocked = "userInfosLevelMaxUnlocked"
        static let kUserInfosDochos = "userInfosDochos"
        static let kUserInfosExperience = "userInfosExperience"
        static let kUserInfosAvatar = "userInfosAvatar"
        static let kUserInfosPassword = "userInfosPassword"
        static let kUserInfosFacebookID = "userInfosFacebookID"
        static let kUserInfosFacebookAccessToken = "userInfosFacebookAccessToken"
        static let kUserInfosGooglePlusID = "userInfosGooglePlusID"
        static let kUserInfosGooglePlusAccessToken = "userInfosGooglePlusAccessToken"
    }
    struct UserAuthentificationKey {
        static let kUserAuthentificationToken = "userAuthTokenKey"
        // Google Plus ID
        static let kGooglePlusClientId = "155812467582-3s7hf6qnffet4s5qf4dpuh5shu64celn.apps.googleusercontent.com"
    }
    
    struct UrlServer {
        
        static let UrlBase = ""
        
        struct UrlRegister {
            static let UrlFacebookRegister = ""
            static let UrlGooglePlusRegister = ""
            static let UrlEmailRegister = ""
        }
        
        struct UrlConnexion {
            static let UrlFacebookConnexion = ""
            static let UrlGooglePlusConnexion = ""
            static let UrlEmailConnexion = "http://localhost:3000/users/sign_in"
        }
    }
}
