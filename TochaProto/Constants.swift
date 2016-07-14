//
//  Constants.swift
//  DochaProto
//
//  Created by Mathis D on 01/05/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

struct UserDataKey {
    static let kUserID = "id"
    static let kUsername = "username"
    static let kLastName = "last_name"
    static let kFirstName = "first_name"
    static let kEmail = "email"
    static let kPassword = "password"
    static let kGender = "sexe"
    static let kDateBirthday = "date_birthday"
    static let kCategoryFavorite = "category_favorite"
    static let kAvatar = "avatar"
    static let kDochos = "dochos"
    static let kExperience = "experience"
    static let kLevelMaxUnlocked = "levelUser"
    static let kPerfectPriceCpt = "perfects"
    static let kFacebookID = "fb_id"
    static let kFacebookToken = "fb_token"
    static let kFacebookImageURL = "fb_image_url"
    static let kImageFBURL = "fb_image_url"
    static let kGooglePlusID = "gplus_id"
    static let kGooglePlusToken = "oauth_token"
    static let kAuthToken = "auth_token"
    static let kSessionID = "session_id"
}

struct Constants {
    struct UserDefaultsKey {
        // User object key
        static let kUserSessionObject = "userSessionObject"
        
        // User infos keys
        static let kUserInfosUserID = "userInfosUserID"
        static let kUserInfosUsername = "userInfosUsername"
        static let kUserInfosLastName = "userInfosLastName"
        static let kUserInfosFirstName = "userInfosFirstName"
        static let kUserInfosEmail = "userInfosEmail"
        static let kUserInfosPassword = "userInfosPassword"
        static let kUserInfosGender = "userInfosGender"
        static let kUserInfosDateBirthday = "userInfosDateBirthday"
        static let kUserInfosCategoryFavorite = "userInfosCategoryFavorite"
        static let kUserInfosLevelMaxUnlocked = "userInfosLevelMaxUnlocked"
        static let kUserInfosDochos = "userInfosDochos"
        static let kUserInfosExperience = "userInfosExperience"
        static let kUserInfosPerfectPriceCpt = "userInfosPerfectPriceCpt"
        static let kUserInfosAvatar = "userInfosAvatar"
        static let kUserInfosAuthToken = "userInfosAuthToken"
        static let kUserInfosSessionID = "userInfosSessionID"
        static let kUserInfosFacebookID = "userInfosFacebookID"
        static let kUserInfosFacebookAccessToken = "userInfosFacebookAccessToken"
        static let kUserInfosFacebookImageURL = "userInfosFacebookImageURL"
        static let kUserInfosGooglePlusID = "userInfosGooglePlusID"
        static let kUserInfosGooglePlusAccessToken = "userInfosGooglePlusAccessToken"
        static let kUserInfosProfileImageFilePath = "userInfosProfileImageFilePath"
        static let kProductsIDPlayed = "userInfosProductsIDPlayed"
    }
    
    struct UserAuthentificationKey {
        static let kUserAuthentificationToken = "userAuthTokenKey"
        // Google Plus ID
        static let kGooglePlusClientId = "155812467582-3s7hf6qnffet4s5qf4dpuh5shu64celn.apps.googleusercontent.com"
    }
    
    struct UrlServer {
        
        static let UrlBase = testing ? "http://localhost:3000" : "https://afternoon-beyond-49404.herokuapp.com"
        
        struct UrlProfil {
            static let UrlProfilUpdate = "/users"
        }
        
        struct UrlRegister {
            static let UrlFacebookRegister = "/users/auth/facebook"
            static let UrlGooglePlusRegister = "/users"
            static let UrlEmailRegister = "/users.json"
        }
        
        struct UrlConnexion {
            static let UrlFacebookConnexion = "/users/auth/facebook"
            static let UrlGooglePlusConnexion = "/users/sign_in" //"/users/auth/google"
            static let UrlEmailConnexion = "/users/sign_in"
        }
    }
}
