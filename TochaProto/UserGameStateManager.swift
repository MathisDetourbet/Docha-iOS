//
//  UserGameStateManager.swift
//  Docha
//
//  Created by Mathis D on 20/06/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

class UserGameStateManager {
    
    struct Rewards {
        var dochos: Int?
        var experience: Int?
        var perfects: Int?
        
        init(dochos: Int, experience: Int, perfects: Int) {
            self.dochos = dochos
            self.experience = experience
            self.perfects = perfects
        }
    }
    
    lazy var userSession: UserSession = UserSessionManager.sharedInstance.currentSession()!
    var estimationResultsArray: [EstimationResult]?
    var currentRewards: Rewards?
    
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
        
        return Double((experience) / (level))
    }
    
    func getUserLevel() -> Int {
        self.userSession = UserSessionManager.sharedInstance.currentSession()!
        return self.userSession.levelMaxUnlocked
    }
    
    func getCurrentDochos() -> Int {
        self.userSession = UserSessionManager.sharedInstance.currentSession()!
        return self.userSession.dochos
    }
    
    func getPerfectPriceNumber() -> Int {
        self.userSession = UserSessionManager.sharedInstance.currentSession()!
        return self.userSession.perfectPriceCpt
    }
    
    func calculRewards() {
        var dochosWon = 0
        var experienceWon = 0
        var perfectNumber = 0
        
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
        
        self.currentRewards = Rewards(dochos: dochosWon, experience: experienceWon, perfects: perfectNumber)
    }
    
    func getRewards() -> Rewards {
        return self.currentRewards!
    }
    
    func saveRewards() {
        self.userSession = UserSessionManager.sharedInstance.currentSession()!
        let experienceToLvlUp = 10 * self.userSession.levelMaxUnlocked
        
        if self.currentRewards!.experience >= experienceToLvlUp {
            // Lvl Up !
            self.userSession.experience = abs(self.userSession.dochos - experienceToLvlUp)
            self.userSession.levelMaxUnlocked += 1
        } else {
            self.userSession.experience += self.currentRewards!.experience!
        }
        
        self.userSession.dochos += self.currentRewards!.dochos!
        self.userSession.perfectPriceCpt += self.currentRewards!.perfects!
        
        self.userSession.saveSession()
    }
}