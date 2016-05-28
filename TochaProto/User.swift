//
//  User.swift
//  DochaProto
//
//  Created by Mathis D on 17/03/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

class User: NSObject {
    var lastName: String?
    var firstName: String?
    var email: String?
    var sexe: String?
    var dateBirthday: NSDate?
    var categoryFavorite: String?
    var avatar: String?
    var levelMaxUnlocked: Int = 1
    var dochos: Int = 0
    var experience: Int = 0
    
//    override init() {
//        super.init()
//    }
//    
//    convenience init(lastName: String?, firstName: String?, email: String?, sexe: String?, dateBirthday: NSDate?, categoryFavorite: String?, avatar: String?, levelMaxUnlocked: Int?, dochos: Int?, experience: Int?) {
//        
//        self.lastName = lastName
//        self.firstName = firstName
//        self.email = email
//        self.sexe = sexe
//        self.dateBirthday = dateBirthday
//        self.categoryFavorite = categoryFavorite
//        self.avatar = avatar
//        self.levelMaxUnlocked = levelMaxUnlocked!
//        self.dochos = dochos!
//        self.experience = experience!
//    }
    
    func initPropertiesWithResponseObject(responseObject: AnyObject) {
        if let dicoUser = responseObject["user"] as? [String: AnyObject] {
            if let lastName = dicoUser["last_name"]?.string { self.lastName = lastName }
            if let firstName = dicoUser["first_name"]?.string { self.firstName = firstName }
            if let email = dicoUser["email"]?.string { self.email = email }
            if let sexe = dicoUser["sexe"]?.string { self.sexe = sexe }
            if let dateBirthday = dicoUser["date_birthday"]?.date { self.dateBirthday = dateBirthday }
            if let categoryFavorite = dicoUser["category_favorite"]?.string { self.categoryFavorite = categoryFavorite }
            if let avatar = dicoUser["avatar"]?.string { self.avatar = avatar }
            if let levelMaxUnlocked = dicoUser["level_max_unlocked"]?.integerValue { self.levelMaxUnlocked = levelMaxUnlocked }
            if let dochos = dicoUser["dochos"]?.integerValue { self.dochos = dochos }
            if let experience = dicoUser["experience"]?.integerValue { self.experience = experience }
        }
    }
}
