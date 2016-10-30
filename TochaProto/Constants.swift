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
    static let kFullName = "fullname"
    static let kEmail = "email"
    static let kPassword = "password"
    static let kPassword1 = "password1"
    static let kPassword2 = "password2"
    static let kOldPassword = "old_password"
    static let kNewPassword1 = "new_password1"
    static let kNewPassword2 = "new_password2"
    static let kGender = "gender"
    static let kDateBirthday = "birthday"
    static let kCategoryPrefered = "categories_prefered"
    static let kAvatarUrl = "avatar"
    static let kDochos = "dochos"
    static let kExperience = "xp"
    static let kLevelMaxUnlocked = "level"
    static let kLevelPercentage = "level_percentage"
    static let kPerfectPriceCpt = "perfects"
    static let kRank = "rank"
    static let kNotifications = "notifications"
    static let kNotificationTokens = "notification_tokens"
    static let kIsOnline = "is_online"
    
    static let kFacebookToken = "access_token"
    static let kDeviceToken = "token"
    
    static let kAuthToken = "key"
    
    static let kBadgesUnlockedIdentifiers = "badges_unlocked_identifiers"
}

struct MatchDataKey {
    static let kId = "id"
    static let kRounds = "rounds"
    static let kMaxRounds = "max_rounds"
    static let kStatus = "status"
    static let kOpponent = "opponent"
    static let kUserScore = "user_score"
    static let kOpponentScore = "opponent_score"
}

struct RoundDataKey {
    static let kId = "id"
    static let kStatus = "status"
    static let kProducts = "products"
    static let kCategory = "category"
    static let kWinner = "winner"
    static let kFirstPlayer = "first_player"
    static let kProposedCategories = "proposed_categories"
    static let kPropositions = "propositions"
    static let kUserScore = "user_score"
    static let kUserTime = "user_time"
    static let kOpponentScore = "opponent_score"
    static let kOpponentTime = "opponent_time"
}

struct ProductDataKey {
    static let kId = "id"
    static let kModel = "name"
    static let kBrand = "brand"
    static let kPrice = "price"
    static let kCategory = "categories"
    static let kimageUrl = "image_url"
    static let kPageUrl = "page_url"
    static let kGender = "gender"
}

struct PropositionDataKey {
    static let kPseudo = "username"
    static let kProductID = "product"
    static let kPrice = "price"
    static let kTimeStamp = "timestamp"
}

struct CategoryDataKey {
    static let kName = "name"
    static let kSlugName = "slug_name"
}

struct Constants {
    struct UserDefaultsKey {
        // User object key
        static let kUserSessionObject = "userSessionObject"
        static let kUserHasFinishedTutorial = "userInfosHasFinishedTutorial"
        
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
        static let kUserInfosLevelPercentage = "userInfosLevelPercentage"
        static let kUserInfosDochos = "userInfosDochos"
        static let kUserInfosExperience = "userInfosExperience"
        static let kUserInfosPerfectPriceCpt = "userInfosPerfectPriceCpt"
        static let kUserInfosRank = "userInfosRank"
        static let kUserInfosAvatarUrl = "userInfosAvatarUrl"
        static let kUserInfosNotifications = "userInfosNotifications"
        static let kuserInfosNotificationTokens = "userInfosNotificationTokens"
        
        static let kUserInfosAuthToken = "userInfosAuthToken"
        
        static let kUserInfosFacebookAccessToken = "userInfosFacebookAccessToken"
        
        static let kUserInfosAvatarImage = "userInfosAvatarImage"
        static let kProductsIDPlayed = "userInfosProductsIDPlayed"
        static let kUserInfosBadgesUnlockedIdentifiers = "userInfosBadgesUnlockedIdentifiers"
        
        static let kDeviceToken = "userInfosDeviceToken"
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
            static let kErrorOccured = "Une erreur est survenue. Essaie à nouveau maintenant ou un peu plus tard."
            static let kErrorNoInternetConnection = "Une erreur est survenue. Tu n'es peut être pas connecter à internet. Essaie de te connecter à nouveau."
            static let kErrorOccuredHomeRedirection = "Une erreur est survenue... Tu seras redirigé vers le menu principal."
            
            static let kErrorRegistrationPasswordMinimumCharacters = "Vérifie que ton mot de passe possède au minimum 6 caractères."
            static let kErrorRegistrationEmailNotValid = "Cette adresse email n'est pas valide."
            static let kErrorRegistrationUsernameAlreadyTaken = "Ce pseudo est déjà pris."
            
            static let kErrorConnexionEmailBadEmailOrPassword = "L'email ou le mot de passe est incorrecte."
            static let kErrorInscriptionBadBirthOrGender = "Les informations ne sont pas valides. Essaie à nouveau."
            static let kErrorNoCategorySelected = "Choisis au minimum une catégorie."
            
            static let kErrorChangePasswordFieldMissing = "Vérifie que tous les champs sont bien remplis."
            static let kErrorChangePasswordNewPwdNotEqual = "Les nouveaux mots de passe sont différents."
            static let kErrorChangePasswordBadOldPwd = "Ce n'est pas le bon ancien mot de passe."
            
        }
        
        struct InfosMessage {
            static let kInfosCategoryHelp = "Nous souhaitons vous proposer au maximum des produits qui vous correspondent."
            static let kUserProfilUpdating = "Mise à jour de ton profil Docha..."
        }
    }
    
    struct UrlServer {
        
        static let UrlBase = testing ? "http://127.0.0.1:8005" : "https://docha.nextmap.io"//10.96.21.10 // 127.0.0.1
        
        struct UrlUser {
            static let UrlUser = "/rest-auth/user/"
            static let UrlChangePassword = "/rest-auth/password/change/"
            static let UrlDeviceToken = "/rest-auth/token"
        }
        
        struct UrlCategory {
            static let UrlAllCategories = "/category"
            static let UrlGetCategory = "/category"
            static let UrlRenewCategies = "/renew"
        }
        
        struct UrlRegister {
            static let UrlEmailRegister = "/rest-auth/registration/"
        }
        
        struct UrlConnexion {
            static let UrlFacebookConnexion = "/rest-auth/facebook/"
            static let UrlEmailConnexion = "/rest-auth/login/"
            static let UrlLogOut = "/rest-auth/logout/"
        }
        
        struct UrlMatch {
            static let UrlGetAllMatch = "/match"
            static let UrlGetMatch = "/match"
            static let UrlPostMatch = "/match"
            static let UrlGetRounds = "/round"
        }
        
        struct UrlSearch {
            static let UrlSearchPlayerByPseudo = "/rest-auth/find"
            static let UrlSearchFacebookFriends = "/rest-auth/friend"
            static let UrlRankingGeneral = "/rest-auth/rank"
        }
    }
}
