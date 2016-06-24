//
//  UserGameStateManager.swift
//  Docha
//
//  Created by Mathis D on 20/06/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

class UserGameStateManager {
    
    lazy var userSession: UserSession = UserSessionManager.sharedInstance.currentSession()!
    
    class var sharedInstance: UserGameStateManager {
        struct Singleton {
            static let instance = UserGameStateManager()
        }
        return Singleton.instance
    }
    
//    func getExperienceProgressionInPercent() -> Double {
//        let experience = userSession.experience
//        let level = userSession.levelMaxUnlocked
//    }
    
    func getCurrentDochos() -> Int {
        return self.userSession.dochos
    }
    
    
}