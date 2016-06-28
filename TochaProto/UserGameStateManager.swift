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
    var estimationResultsArray: [EstimationResult]?
    var perfectNumber: Int = 0
    
    
    class var sharedInstance: UserGameStateManager {
        struct Singleton {
            static let instance = UserGameStateManager()
        }
        return Singleton.instance
    }
    
    func getExperienceProgressionInPercent() -> Double {
        self.userSession = UserSessionManager.sharedInstance.currentSession()!
        let experience = userSession.experience
        let level = userSession.levelMaxUnlocked
        
        return Double((experience * 100) / (level * 10))
    }
    
    func getCurrentDochos() -> Int {
        self.userSession = UserSessionManager.sharedInstance.currentSession()!
        return self.userSession.dochos
    }
    
    func getPerfectPriceNumber() -> Int {
        self.userSession = UserSessionManager.sharedInstance.currentSession()!
        return self.userSession.perfectPriceCpt
    }
    
    func getRewardsWithEstimationResultArray() -> (dochos: Int, exprience: Int) {
        var dochosWon = 0
        var experienceWon = 0
        
        for result in self.estimationResultsArray! {
            if result == .Perfect {
                dochosWon += 50
                experienceWon += 10
                perfectNumber += 1
            } else if (result == .Amazing) || (result == .Great) {
                dochosWon += 10
            }
        }
        experienceWon += 5
        
        return (dochosWon, experienceWon)
    }
    
    func updateRewardsWithDochos(dochos: Int, andExperience experience: Int) {
        self.userSession = UserSessionManager.sharedInstance.currentSession()!
        let experienceToLvlUp = 10 * self.userSession.levelMaxUnlocked
        if experience >= experienceToLvlUp {
            // Lvl Up !
            self.userSession.experience = abs(self.userSession.dochos - experienceToLvlUp)
            self.userSession.levelMaxUnlocked += 1
        } else {
            self.userSession.experience += experience
        }
        self.userSession.dochos += dochos
        
        self.userSession.saveSession()
    }
}