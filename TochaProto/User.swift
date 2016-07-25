//
//  User.swift
//  DochaProto
//
//  Created by Mathis D on 17/03/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

enum ProfilImageType : Int {
    case FacebookImage
    case AvatarDochaImage
    case PhotoImage
}

class User: NSObject {
    var userID: Int?
    var username: String?
    var lastName: String?
    var firstName: String?
    var email: String?
    var gender: String?
    var dateBirthday: NSDate?
    var categoryFavorite: String?
    var avatar: String?
    var levelMaxUnlocked: Int = 1
    var dochos: Int = 0
    var experience: Int = 0
    var perfectPriceCpt: Int = 0
    var profilImagePrefered: ProfilImageType = .FacebookImage
    
    override init() {}
    
    init(userID: Int?, username: String?, lastName: String?, firstName: String?, email: String?, gender: String?, dateBirthday: NSDate?, categoryFavorite: String?, avatar: String?, levelMaxUnlocked: Int?, dochos: Int?, experience: Int?, perfectPriceCpt: Int?, profilImagePrefered: ProfilImageType?) {
        self.userID = userID
        self.username = username
        self.lastName = lastName
        self.firstName = firstName
        self.email = email
        self.gender = gender
        self.dateBirthday = dateBirthday
        self.categoryFavorite = categoryFavorite
        self.avatar = avatar
        self.levelMaxUnlocked = levelMaxUnlocked!
        self.dochos = dochos!
        self.experience = experience!
        self.perfectPriceCpt = perfectPriceCpt!
        self.profilImagePrefered = profilImagePrefered!
    }
    
    func initPropertiesWithResponseObject(responseObject: AnyObject) {
        if let dicoUser = responseObject["user"] as? [String: AnyObject] {
            if let userID = dicoUser["id"]?.integerValue { self.userID = userID }
            if let userName = dicoUser["username"]?.string { self.username = userName }
            if let lastName = dicoUser["last_name"]?.string { self.lastName = lastName }
            if let firstName = dicoUser["first_name"]?.string { self.firstName = firstName }
            if let email = dicoUser["email"]?.string { self.email = email }
            if let gender = dicoUser["gender"]?.string { self.gender = gender }
            if let dateBirthday = dicoUser["date_birthday"]?.date { self.dateBirthday = dateBirthday }
            if let categoryFavorite = dicoUser["category_favorite"]?.string { self.categoryFavorite = categoryFavorite }
            if let avatar = dicoUser["avatar"]?.string { self.avatar = avatar }
            if let levelMaxUnlocked = dicoUser["level_max_unlocked"]?.integerValue { self.levelMaxUnlocked = levelMaxUnlocked }
            if let dochos = dicoUser["dochos"]?.integerValue { self.dochos = dochos }
            if let experience = dicoUser["experience"]?.integerValue { self.experience = experience }
            if let perfectPriceCpt = dicoUser["perfect_price_cpt"]?.integerValue { self.perfectPriceCpt = perfectPriceCpt }
        }
    }
}
