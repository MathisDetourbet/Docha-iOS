//
//  Constants.swift
//  DochaProto
//
//  Created by Mathis D on 01/05/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation

struct UserDataKey {
    static let kUsername = "username"
    static let kLastName = "last_name"
    static let kFirstName = "first_name"
    static let kEmail = "email"
    static let kPassword = "password"
    static let kPassword1 = "password1"
    static let kPassword2 = "password2"
    static let kGender = "gender"
    static let kDateBirthday = "birthday"
    static let kCategoryPrefered = "categories_prefered"
    static let kAvatarUrl = "avatar"
    static let kDochos = "dochos"
    static let kExperience = "experience"
    static let kLevelMaxUnlocked = "levelUser"
    static let kPerfectPriceCpt = "perfects"
    
    static let kFacebookToken = "access_token"
    
    static let kAuthToken = "key"
    static let kSessionID = "session_id"
    static let kBadgesUnlockedIdentifiers = "badges_unlocked_identifiers"
    
    static let kCategoryName = "name"
    static let kCategorySlugName = "slug_name"
}

struct Constants {
    struct UserDefaultsKey {
        // User object key
        static let kUserSessionObject = "userSessionObject"
        
        // User infos keys
        static let kUserInfosPseudo = "userInfosPseudo"
        static let kUserInfosLastName = "userInfosLastName"
        static let kUserInfosFirstName = "userInfosFirstName"
        static let kUserInfosEmail = "userInfosEmail"
        static let kUserInfosPassword = "userInfosPassword"
        static let kUserInfosGender = "userInfosGender"
        static let kUserInfosDateBirthday = "userInfosDateBirthday"
        static let kUserInfosCategoryName = "userInfosCategoryName"
        static let kUserInfosCategorySlugName = "userInfosCategorySlugName"
        static let kUserInfosCategoryPrefered = "userInfosCategoryPrefered"
        static let kUserInfosLevelMaxUnlocked = "userInfosLevelMaxUnlocked"
        static let kUserInfosDochos = "userInfosDochos"
        static let kUserInfosExperience = "userInfosExperience"
        static let kUserInfosPerfectPriceCpt = "userInfosPerfectPriceCpt"
        static let kUserInfosAvatarUrl = "userInfosAvatarUrl"
        
        static let kUserInfosAuthToken = "userInfosAuthToken"
        
        static let kUserInfosFacebookAccessToken = "userInfosFacebookAccessToken"
        
        static let kUserInfosProfileImageFilePath = "userInfosProfileImageFilePath"
        static let kProductsIDPlayed = "userInfosProductsIDPlayed"
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
    
    struct PopupMessage {
        struct ErrorMessage {
            static let kErrorNoInternetConnection = "Une erreur est survenue. Essaie de te connecter à nouveau"
            static let kErrorRegistrationPasswordMinimumCharacters = "Vérifie que ton mot de passe possède au minimum 6 caractères."
            static let kErrorRegistrationEmailNotValid = "Cette adresse email n'est pas valide."
            static let kErrorConnexionEmailBadEmailOrPassword = "L'email ou le mot de passe est incorrecte."
            static let kErrorInscriptionBadBirthOrGender = "Les informations ne sont pas valides. Essaie à nouveau."
        }
        
        struct InfosMessage {
            static let kInfosCategoryHelp = "Nous souhaitons vous proposer au maximum des produits qui vous correspondent."
        }
    }
    
    struct UrlServer {
        
        static let UrlBase = testing ? "http://127.0.0.1:8005" : "https://afternoon-beyond-49404.herokuapp.com"
        
        struct UrlUser {
            static let UrlUser = "/rest-auth/user/"
        }
        
        struct UrlCategory {
            static let UrlAllCategory = "/category"
            static let UrlGetCategory = "/category"
        }
        
        struct UrlRegister {
            static let UrlEmailRegister = "/rest-auth/registration/"
        }
        
        struct UrlConnexion {
            static let UrlFacebookConnexion = "/rest-auth/facebook/"
            static let UrlEmailConnexion = "/rest-auth/login/"
            static let UrlLogOut = "/rest-auth/logout/"
        }
    }
}
