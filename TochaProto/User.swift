//
//  User.swift
//  DochaProto
//
//  Created by Mathis D on 17/03/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation

enum ProfilImageType : Int {
    case facebookImage
    case avatarDochaImage
    case photoImage
}

class User: NSObject {
    var userID: Int?
    var pseudo: String?
    var lastName: String?
    var firstName: String?
    var email: String?
    var gender: String?
    var dateBirthday: Date?
    var categoriesFavorites: [String]?
    var avatar: String?
    var levelMaxUnlocked: Int = 1
    var dochos: Int = 0
    var experience: Int = 0
    var perfectPriceCpt: Int = 0
    var badgesUnlockedIdentifiers: [String]?
    
    override init() {}
    
    init(userID: Int?, pseudo: String?, lastName: String?, firstName: String?, email: String?, gender: String?, dateBirthday: Date?, categoriesFavorites: [String]?, avatar: String?, levelMaxUnlocked: Int?, dochos: Int?, experience: Int?, perfectPriceCpt: Int?, badgesUnlockedIdentifiers: [String]?) {
        self.userID = userID
        self.pseudo = pseudo
        self.lastName = lastName
        self.firstName = firstName
        self.email = email
        self.gender = gender
        self.dateBirthday = dateBirthday
        self.categoriesFavorites = categoriesFavorites
        self.avatar = avatar
        self.levelMaxUnlocked = levelMaxUnlocked!
        self.dochos = dochos!
        self.experience = experience!
        self.perfectPriceCpt = perfectPriceCpt!
        self.badgesUnlockedIdentifiers = badgesUnlockedIdentifiers
    }
    
    func initPropertiesWithResponseObject(_ responseObject: AnyObject) {
        if let dicoUser = responseObject["user"] as? [String: AnyObject] {
            if let userID = dicoUser["id"]?.integerValue { self.userID = userID }
            if let pseudo = dicoUser["pseudo"]?.string { self.pseudo = pseudo }
            if let lastName = dicoUser["last_name"]?.string { self.lastName = lastName }
            if let firstName = dicoUser["first_name"]?.string { self.firstName = firstName }
            if let email = dicoUser["email"]?.string { self.email = email }
            if let gender = dicoUser["gender"]?.string { self.gender = gender }
            if let dateBirthday = dicoUser["date_birthday"]?.date { self.dateBirthday = dateBirthday }
            if let categoriesFavorites = dicoUser["category_favorite"]?.array { self.categoriesFavorites = categoriesFavorites as? [String] }
            if let avatar = dicoUser["avatar"]?.string { self.avatar = avatar }
            if let levelMaxUnlocked = dicoUser["level_max_unlocked"]?.integerValue { self.levelMaxUnlocked = levelMaxUnlocked }
            if let dochos = dicoUser["dochos"]?.integerValue { self.dochos = dochos }
            if let experience = dicoUser["experience"]?.integerValue { self.experience = experience }
            if let perfectPriceCpt = dicoUser["perfect_price_cpt"]?.integerValue { self.perfectPriceCpt = perfectPriceCpt }
            if let badgesUnlockedIdentifiers = dicoUser["badges_unlocked"]?.array as? [String] { self.badgesUnlockedIdentifiers = badgesUnlockedIdentifiers }
        }
    }
}
