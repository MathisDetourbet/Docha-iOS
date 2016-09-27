//
//  UserGameStateManager.swift
//  Docha
//
//  Created by Mathis D on 20/06/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation
import GameKit

enum EstimationResult {
    case Perfect
    case Amazing
    case Great
    case Oups
}

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
    
    lazy var userSession: UserSession? = UserSessionManager.sharedInstance.currentSession()!
    var estimationResultsArray: [EstimationResult]?
    var psyAndRealPriceArray: [(psyPrice: Int, realPrice: Int)]?
    var gameRewards: [Reward]?
    var hasLevelUp: Bool = false
    var hasUnlockedBadge: Bool = false
    var dochosAchievement: Int = 0
    
    class var sharedInstance: UserGameStateManager {
        struct Singleton {
            static let instance = UserGameStateManager()
        }
        return Singleton.instance
    }
    
    func getExperienceProgressionInPercent() -> Double {
        let currentExperience = getUserExperience()
        let currentLevel = getUserLevel()
        
        let nextLevelXP = currentLevel * 100
        let currentExperienceInPercent = Double((currentExperience * 100) / nextLevelXP)
        
        return currentExperienceInPercent
    }
    
    func getUserLevel() -> Int {
        userSession = UserSessionManager.sharedInstance.currentSession()
        if let userSession = self.userSession {
            return userSession.levelMaxUnlocked
        }
        
        return 1
    }
    
    func getUserExperience() -> Int {
        userSession = UserSessionManager.sharedInstance.currentSession()
        if let userSession = self.userSession {
            return userSession.experience
        }
        
        return 0
    }
    
    func getCurrentDochos() -> Int {
        userSession = UserSessionManager.sharedInstance.currentSession()
        if let userSession = self.userSession {
            return userSession.dochos
        }
        
        return 0
    }
    
    func getGameRewards() -> [Reward]? {
        return gameRewards
    }
    
    func getPerfectPriceNumber() -> Int {
        userSession = UserSessionManager.sharedInstance.currentSession()!
        if let userSession = self.userSession {
            return userSession.perfectPriceCpt
        }
        
        return 0
    }
    
    func calculRewards() {
        gameRewards = [Reward]()
        
        if psyAndRealPriceArray != nil {
            for price in psyAndRealPriceArray! {
                let reward = getRewardForPsyPrice(Double(price.psyPrice), andRealPrice: Double(price.realPrice))
                gameRewards?.append(Reward(dochos: reward.dochos, experience: reward.experience, perfect: reward.perfect))
            }
        }
    }
    
    // Return the reward for the user : (X_Dochos, Y_XP)
    func getRewardForPsyPrice(let psyPrice: Double, andRealPrice realPrice: Double) -> (dochos: Int, experience: Int, perfect: Bool) {
        let maxDochos: Double = round(realPrice * MULTIPLE_DOCHOS)
        
        if psyPrice == realPrice {  // Perfect price !
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
            else { // user will get no points
                return (0, XP_PLAYED, false)
            }
        }
    }
    
    func isPsyPriceInIntervalle(let psyPrice: Double, andRealPrice realPrice: Double) -> Bool {
        if psyPrice == realPrice {
            return true
            
        } else {
            let priceMax = realPrice + realPrice * ERROR_PERCENT
            let priceMin = realPrice - realPrice * ERROR_PERCENT
            
            if case priceMin...priceMax = psyPrice { return true }
            else { return false }
        }
    }
    
    func saveRewards() {
        if let userSession = userSession {
            hasLevelUp = false
            hasUnlockedBadge = false
            //userSession = UserSessionManager.sharedInstance.currentSession()
            var newTotalDochos = userSession.dochos
            var currentExperience = userSession.experience
            var newCurrentExperience = currentExperience
            var newGameExperience = 0
            var newTotalPerfect = userSession.perfectPriceCpt
            let currentLevel = getUserLevel()
            var newCurrentLevel = currentLevel
            
            if gameRewards == nil {
                return
            }
            
            for reward in gameRewards! {
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
                hasLevelUp = true
                
            } else {
                newCurrentExperience = currentExperience
            }
            
            // Game Center Achievements
            let achievementsArray = updateAchievements(newTotalPerfect)
            if let achievementsArray = achievementsArray {
                reportAchievements(achievementsArray)
            }
            
            userSession.dochos = newTotalDochos + self.dochosAchievement
            userSession.experience = newCurrentExperience
            userSession.perfectPriceCpt = newTotalPerfect
            userSession.levelMaxUnlocked = newCurrentLevel
            userSession.saveSession()
        }
    }
    
    
//MARK: Game Center Methods
    
    func authenticateLocalPlayer() {
        let localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            if ((viewController) != nil) {
                UIApplication.topViewController()!.presentViewController(viewController!, animated: true, completion: nil)
                
            } else {
                UserGameStateManager.sharedInstance.loadAchievementsFromGameCenter()
            }
        }
    }
    
    func loadAchievementsFromGameCenter() {
        let userSession = UserSessionManager.sharedInstance.currentSession()
        var badgesUnlockedIdentifiers = userSession?.badgesUnlockedIdentifiers
        if badgesUnlockedIdentifiers == nil {
            badgesUnlockedIdentifiers = []
        }
        
        GKAchievement.loadAchievementsWithCompletionHandler { (allAchievementsArray, error) in
            if error != nil {
                print("Game Center error : Couldn't load user achievements whith error : \(error)")
                
            } else {
                if(allAchievementsArray != nil) {
                    for achievement in allAchievementsArray! {
                        if let achievement: GKAchievement = achievement {
                            if ((badgesUnlockedIdentifiers?.contains(achievement.identifier!))! == false) {
                                badgesUnlockedIdentifiers?.append(achievement.identifier!)
                            }
                        }
                    }
                    
                    userSession?.badgesUnlockedIdentifiers = badgesUnlockedIdentifiers
                    userSession?.saveSession()
                }
            }
        }
    }
    
    func updateAchievements(newTotalPerfect: Int) -> [GKAchievement]? {
        dochosAchievement = 0
        if let userSession = self.userSession {
            var badgesUnlockedArray = userSession.badgesUnlockedIdentifiers
            if badgesUnlockedArray == nil {
                badgesUnlockedArray = []
            }
            
            var achievementsArray: [GKAchievement] = []
            let allBadgesIdentifiers = Constants.GameCenterLeaderBoardIdentifiers.kBadgesIdentifiers
            let perfectNumberBadgeDico = [allBadgesIdentifiers[0] : 5, allBadgesIdentifiers[1] : 25, allBadgesIdentifiers[2] : 100, allBadgesIdentifiers[3] : 500]
            let dochosRewardsPerfects = [allBadgesIdentifiers[0] : 25, allBadgesIdentifiers[1] : 100, allBadgesIdentifiers[2] : 500, allBadgesIdentifiers[3] : 3000]
            
            for (identifier, perfects) in perfectNumberBadgeDico {
                if newTotalPerfect >= perfects && ((badgesUnlockedArray?.contains(identifier))! == false) {
                    badgesUnlockedArray?.append(identifier)
                    hasUnlockedBadge = true
                    dochosAchievement += dochosRewardsPerfects[identifier]!
                    let achievement = GKAchievement(identifier: identifier)
                    if newTotalPerfect >= perfects {
                        achievement.percentComplete = 100.0
                    } else {
                        achievement.percentComplete = (Double(newTotalPerfect) / Double(perfects)) * 100
                    }
                    achievementsArray.append(achievement)
                }
            }
            
            let newPerfects = newTotalPerfect - userSession.perfectPriceCpt
            let perfectFollowingNumberBadgeDico = [allBadgesIdentifiers[4] : 3, allBadgesIdentifiers[5] : 4, allBadgesIdentifiers[6] : 5]
            let dochosRewardsPerfectsFollowing = [allBadgesIdentifiers[4] : 500, allBadgesIdentifiers[5] : 1000, allBadgesIdentifiers[6] : 5000]
            
            if newPerfects >= 3 {
                for (identifier, perfects) in perfectFollowingNumberBadgeDico {
                    if newPerfects >= perfects && ((badgesUnlockedArray?.contains(identifier))! == false) {
                        badgesUnlockedArray?.append(identifier)
                        hasUnlockedBadge = true
                        dochosAchievement += dochosRewardsPerfectsFollowing[identifier]!
                        let achievement = GKAchievement(identifier: identifier)
                        if newPerfects >= perfects {
                            achievement.percentComplete = 100.0
                        } else {
                            achievement.percentComplete = (Double(newTotalPerfect) / Double(perfects)) * 100
                        }
                        achievementsArray.append(achievement)
                    }
                }
            }
            userSession.badgesUnlockedIdentifiers = badgesUnlockedArray
            
            return achievementsArray
        }
        
        return nil
    }
    
    func reportAchievement(identifier: String, percentComplete: Double) {
        if GKLocalPlayer.localPlayer().authenticated {
            let achievement = GKAchievement(identifier: identifier)
            achievement.percentComplete = percentComplete
            let achievementArray: [GKAchievement] = [achievement]
            GKAchievement.reportAchievements(achievementArray, withCompletionHandler: { (error) in
                if error != nil {
                    print("Game Center report achievement error: \(error)")
                    
                } else {
                    print("Game Center report achievement successful")
                    
                }
            })
        }
    }
    
    func reportAchievements(achievementsArray: [GKAchievement]) {
        if GKLocalPlayer.localPlayer().authenticated {
            GKAchievement.reportAchievements(achievementsArray, withCompletionHandler: { (error) in
                if error != nil {
                    print("Game Center report achievements error: \(error)")
                    
                } else {
                    print("Game Center report achievements successful")
                    
                }
            })
        }
    }
}