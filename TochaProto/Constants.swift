//
//  Constants.swift
//  DochaProto
//
//  Created by Mathis D on 01/05/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation

struct UserDataKey {
    static let kUserID = "id"
    static let kPseudo = "pseudo"
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
    static let kFacebookToken = "access_token"
    static let kCodeApi = "code"
    static let kFacebookImageURL = "fb_image_url"
    static let kImageFBURL = "fb_image_url"
    static let kAuthToken = "auth_token"
    static let kSessionID = "session_id"
    static let kBadgesUnlockedIdentifiers = "badges_unlocked_identifiers"
}

struct Constants {
    struct UserDefaultsKey {
        // User object key
        static let kUserSessionObject = "userSessionObject"
        
        // User infos keys
        static let kUserInfosUserID = "userInfosUserID"
        static let kUserInfosPseudo = "userInfosPseudo"
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
        static let kProfilImagePrefered = "userInfoProfilImagePrefered"
        static let kUserInfosBadgesUnlockedIdentifiers = "userInfosBadgesUnlockedIdentifiers"
    }
    
    struct DataRecordsKey {
        static let kDataRecordUserID = "user_id"
        static let kDataRecordProductID = "product_id"
        static let kDataRecordPsyPrice = "psy_price"
        static let kDataRecordIsInIntervalle = "is_in_intervalle"
        static let kDataRecordResponseTime = "response_time"
        static let kDataRecordHadTimeToGiveAnswer = "had_time_to_give_answer"
    }
    
    struct UserAuthentificationKey {
        static let kUserAuthentificationToken = "userAuthTokenKey"
        static let kGooglePlusClientId = "155812467582-3s7hf6qnffet4s5qf4dpuh5shu64celn.apps.googleusercontent.com"
    }
    
    struct GameCenterLeaderBoardIdentifiers {
        static let kBadgesIdentifiers = ["docha.leaderboard_total_perfects_5", "docha.leaderboard_total_perfects_25", "docha.leaderboard_total_perfects_100", "docha.leaderboard_total_perfects_500", "docha.leaderboard_following_perfects_3", "docha.leaderboard_following_perfects_4", "docha.leaderboard_following_perfects_5"]
    }
    
    struct UrlServer {
        
        static let UrlBase = testing ? "http://127.0.0.1:8005" : "https://afternoon-beyond-49404.herokuapp.com"
        
        struct UrlUser {
            static let UrlGetUser = "/rest-auth/user/"
        }
        
        struct UrlRegister {
            static let UrlFacebookRegister = "/rest-auth/facebook/"
            static let UrlEmailRegister = "/rest-auth/registration/"
        }
        
        struct UrlConnexion {
            static let UrlFacebookConnexion = "/rest-auth/facebook/"
            static let UrlEmailConnexion = "/rest-auth/registration/"
            static let UrlLogOut = ""
        }
    }
}
