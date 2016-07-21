//
//  UserGameStateManager.swift
//  Docha
//
//  Created by Mathis D on 20/06/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

struct Reward {
    var dochos: Int?
    var experience: Int?
    var perfect: Bool?
    
    init(dochos: Int, experience: Int, perfect: Bool) {
        self.dochos = dochos
        self.experience = experience
        self.perfect = perfect
    }
}

class UserGameStateManager {
    
    let ERROR_PERCENT = 0.2
    let MULTIPLE_DOCHOS = 0.2
    
    let DOCHOS_PERFECT = 20
    
    let XP_PLAYED = 10
    let XP_PERFECT = 40
    
    lazy var userSession: UserSession = UserSessionManager.sharedInstance.currentSession()!
    var estimationResultsArray: [EstimationResult]?
    var psyAndRealPriceArray: [(psyPrice: Int, realPrice: Int)]?
    var gameRewards: [Reward]?
    
    class var sharedInstance: UserGameStateManager {
        struct Singleton {
            static let instance = UserGameStateManager()
        }
        return Singleton.instance
    }
    
//    func calculProgressionInPercent() -> Double {
//        
//        let currentExperience = getUserExperience()
//        
//        
////        let experience = Double(self.userSession.experience / 100)
////        
////        if experience == 0 {
////            return (0.0, 1)
////        }
////        
////        let currentLevel = log(experience + 1.0) + (1 - log(2.0)) * 1.25
////        let progression = currentLevel - (floor(currentLevel) * 1)
////        
////        return (progression, Int(floor(currentLevel)))
//    }
    
    func getExperienceProgressionInPercent() -> Double {
        let currentExperience = getUserExperience()
        let currentLevel = getUserLevel()
        
        let nextLevelXP = currentLevel * 100
        let currentExperienceInPercent = Double((currentExperience * 100) / nextLevelXP)
        
        return currentExperienceInPercent
    }
    
    func getUserLevel() -> Int {
        self.userSession = UserSessionManager.sharedInstance.currentSession()!
        return self.userSession.levelMaxUnlocked
    }
    
    func getUserExperience() -> Int {
        self.userSession = UserSessionManager.sharedInstance.currentSession()!
        return self.userSession.experience
    }
    
    func getCurrentDochos() -> Int {
        self.userSession = UserSessionManager.sharedInstance.currentSession()!
        return self.userSession.dochos
    }
    
    func getGameRewards() -> [Reward]? {
        return self.gameRewards
    }
    
    func getPerfectPriceNumber() -> Int {
        self.userSession = UserSessionManager.sharedInstance.currentSession()!
        return self.userSession.perfectPriceCpt
    }
    
    func calculRewards() {
        self.gameRewards = [Reward]()
        
        if self.psyAndRealPriceArray != nil {
            for price in self.psyAndRealPriceArray! {
                let reward = getRewardForPsyPrice(Double(price.psyPrice), andRealPrice: Double(price.realPrice))
                self.gameRewards?.append(Reward(dochos: reward.dochos, experience: reward.experience, perfect: reward.perfect))
            }
        }
    }
    
    // Return the reward for the user : (X_Dochos, Y_XP)
    func getRewardForPsyPrice(let psyPrice: Double, andRealPrice realPrice: Double) -> (dochos: Int, experience: Int, perfect: Bool) {
        let maxDochos: Double = round(realPrice * MULTIPLE_DOCHOS)
        
        if psyPrice == realPrice {
            // Perfect price !
            return (DOCHOS_PERFECT + Int(maxDochos), XP_PERFECT + XP_PLAYED, true)
        }
        else {
            let priceMax = realPrice + realPrice * ERROR_PERCENT
            let priceMin = realPrice - realPrice * ERROR_PERCENT
            
            if case priceMin...priceMax = psyPrice {
                let errorRange = abs(realPrice-psyPrice)
                let delta = priceMax - realPrice
                let userErrorPercentInRange = errorRange / delta * 100
                let dochosWon = abs(Int(round(maxDochos * (100-userErrorPercentInRange) / 100)))
                let xpBonus = Int((XP_PERFECT * Int(100-userErrorPercentInRange)) / 100)
                
                return (dochosWon, XP_PLAYED + xpBonus, false)
            }
            else {
                // user will get no points
                return (0, XP_PLAYED, false)
            }
        }
    }
    
    func saveRewards() {
        self.userSession = UserSessionManager.sharedInstance.currentSession()!
        var newTotalDochos = userSession.dochos
        var currentExperience = userSession.experience
        var newCurrentExperience = currentExperience
        var newGameExperience = 0
        var newTotalPerfect = userSession.perfectPriceCpt
        let currentLevel = getUserLevel()
        var newCurrentLevel = currentLevel
        
        if self.gameRewards == nil {
            return
        }
        
        for reward in self.gameRewards! {
            newTotalDochos += reward.dochos!
            newGameExperience += reward.experience!
            if reward.perfect! {
                newTotalPerfect += 1
            }
        }
        
        currentExperience += newGameExperience
        let nextLevelExperience = currentLevel * 100
        
        if currentExperience >= nextLevelExperience {
            newCurrentLevel += 1
            newCurrentExperience = currentExperience - nextLevelExperience
            
        } else {
            newCurrentExperience = currentExperience
        }
        
        self.userSession.dochos = newTotalDochos
        
        self.userSession.experience = newCurrentExperience
        self.userSession.perfectPriceCpt = newTotalPerfect
        self.userSession.levelMaxUnlocked = newCurrentLevel
        
        self.userSession.saveSession()
    }
}