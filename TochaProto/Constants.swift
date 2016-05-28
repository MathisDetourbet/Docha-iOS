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
        static let kUserInfosSexe = "userInfosSexe"
        static let kUserInfosDateBirthday = "userInfosDateBirthday"
        static let kUserInfosCategoryFavorite = "userInfosCategoryFavorite"
        static let kUserInfosLevelMaxUnlocked = "userInfosLevelMaxUnlocked"
        static let kUserInfosDochos = "userInfosDochos"
        static let kUserInfosExperience = "userInfosExperience"
        static let kUserInfosAvatar = "userInfosAvatar"
    }
    struct UserAuthentificationKey {
        static let kUserAuthentificationToken = "userAuthTokenKey"
    }
}
