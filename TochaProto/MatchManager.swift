//
//  MatchManager.swift
//  Docha
//
//  Created by Mathis D on 10/10/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Kingfisher

class MatchManager {
    
    var matchRequest: MatchRequest?
    var roundRequest: RoundRequest?
    var searchRequest: SearchRequest?
    
    var userSessionManager: UserSessionManager = UserSessionManager.sharedInstance
    
    var currentMatch: Match?
    var currentRound: Round?
    var userPlayer: Player?
    var opponentPlayer: Player?
    var matchArray: [Match]?
    
    class var sharedInstance: MatchManager {
        struct Singleton {
            static let instance = MatchManager()
        }
        return Singleton.instance
    }
    
    func loadPlayersInfos(withCompletion completion: @escaping() -> Void) {
        
        // User Player
        let userData = userSessionManager.getUserInfosAndAvatarImage()
        
        if let user = userData.user, let avatarImage = userData.avatarImage {
            let image = avatarImage
            let avatarUrl = user.avatarUrl ?? "avatar_man_large"
            let playerType: PlayerType = userSessionManager.currentSession()!.isKind(of: UserSessionFacebook.self) ? .facebookPlayer : .emailPlayer
            
            let userPlayer = Player(pseudo: user.pseudo ?? Player.defaultPlayer().pseudo,
                                    fullName: "\(user.firstName) \(user.lastName)",
                                    gender: user.gender ?? Gender.universal,
                                    avatarUrl: avatarUrl,
                                    avatarImage: image,
                                    playerType: playerType,
                                    level: user.levelMaxUnlocked ?? nil,
                                    dochos: user.dochos,
                                    perfects: user.perfectPriceCpt,
                                    isOnline: true)
            
            self.userPlayer = userPlayer
        }
        
        
        // Opponent Player
        let opponentPlayer: Player
        
        if let match = self.currentMatch {
            opponentPlayer = Player(player: match.opponent)
            
            if opponentPlayer.playerType == .emailPlayer {
                opponentPlayer.avatarImage = nil
                self.opponentPlayer = opponentPlayer
                completion()
                
            } else {
                let url = URL(string: opponentPlayer.avatarUrl)
                ImageDownloader.default.downloadImage(with: url!, options: [], progressBlock: nil,
                    completionHandler: { (image, error, _, _) in
                        if error != nil {
                            debugPrint(error as! Error)
                            completion()
                            return
                        }
                        
                        opponentPlayer.avatarImage = image
                        self.opponentPlayer = opponentPlayer
                        completion()
                    }
                )
            }
            
        } else {
            opponentPlayer = Player.defaultPlayer()
            opponentPlayer.avatarImage = UIImage(named: opponentPlayer.avatarUrl + "large")
            self.opponentPlayer = opponentPlayer
            completion()
        }
    }
    
    func hasAlreadyMatch(with player: Player) -> Bool {
        let pseudo = player.pseudo
        let notFinishedMatchStatus: [MatchStatus] = [.userTurn, .opponentTurn, .waiting]
        
        if let allMatch = matchArray {
            for match in allMatch {
                if match.opponent.pseudo == pseudo && notFinishedMatchStatus.contains(match.status) {
                    return true
                }
            }
        }
        
        return false
    }
    
    func getMatch(for player: Player) -> Match? {
        let pseudo = player.pseudo
        let notFinishedMatchStatus: [MatchStatus] = [.userTurn, .opponentTurn, .waiting]
        
        if let allMatch = matchArray {
            for match in allMatch {
                if match.opponent.pseudo == pseudo && notFinishedMatchStatus.contains(match.status) {
                    return match
                }
            }
        }
        
        return nil
    }
    
    
//MARK: Match Requests
	
    func getAllMatch(success: @escaping (_ matchArray: [Match]) -> Void, fail failure: @escaping (_ error: Error?) -> Void) {
        guard let authToken = userSessionManager.getAuthToken() else {
            failure(DochaRequestError.authTokenNotFound)
            return
        }
        
        matchRequest = MatchRequest()
        matchRequest?.getAllMatch(withAuthToken: authToken,
            success: { (matchArray) in
                
                self.matchArray = matchArray
                success(matchArray)
                
            }, fail: { (error) in
                failure(error)
            }
        )
    }
    
    func postMatch(withOpponentPseudo opponentPseudo: String? = nil, success: @escaping(_ match: Match) -> Void, fail failure: @escaping(_ error: Error?) -> Void) {
        guard let authToken = userSessionManager.getAuthToken() else {
            failure(DochaRequestError.authTokenNotFound)
            return
        }
        
        matchRequest = MatchRequest()
        
        if let opponentPseudo = opponentPseudo {
            matchRequest?.postMatch(withAuthToken: authToken, andOpponentPseudo: opponentPseudo,
                success: { (match) in
                    
                    self.currentMatch = match
                    self.opponentPlayer = match.opponent
                    success(match)
                    
                }, fail: { (error) in
                    failure(error)
                }
            )
            
        } else {
            matchRequest?.postMatch(withAuthToken: authToken,
                success: { (match) in
                    
                    self.currentMatch = match
                    self.opponentPlayer = match.opponent
                    success(match)
                    
                }, fail: { (error) in
                    failure(error)
                }
            )
        }
    }
    
    func getMatch(withMatchID matchID: Int!, success: @escaping(_ match: Match) -> Void, fail failure: @escaping(_ error: Error?) -> Void) {
        guard let authToken = userSessionManager.getAuthToken() else {
            failure(DochaRequestError.authTokenNotFound)
            return
        }
        
        matchRequest = MatchRequest()
        matchRequest?.getMatch(withAuthToken: authToken, andMatchID: matchID,
            success: { (match) in
                
                self.currentMatch = match
                self.opponentPlayer = match.opponent
                success(match)
                
                
            }, fail: { (error) in
                failure(error)
            }
        )
    }
    
    func deleteMatch(ForMatchID matchID: Int!, andRoundID roundID: Int!, success: @escaping() -> Void, fail failure: @escaping (_ error: Error?) -> Void) {
        guard let authToken = userSessionManager.getAuthToken() else {
            failure(DochaRequestError.authTokenNotFound)
            return
        }
        
        matchRequest = MatchRequest()
        matchRequest?.deleteMatch(withAuthToken: authToken, andMatchID: matchID,
            success: {
                success()
                
            }, fail: { (error) in
                failure(error)
            }
        )
    }
    
    
//MARK: Round Requests
    
    func getAllRounds(withMatchID matchID: Int!, success: @escaping (_ roundsFull: [RoundFull]) -> Void, fail failure: @escaping (_ error: Error?) -> Void) {
        guard let authToken = userSessionManager.getAuthToken() else {
            failure(DochaRequestError.authTokenNotFound)
            return
        }
        
        roundRequest = RoundRequest()
        roundRequest?.getAllRounds(withAuthToken: authToken, ForMatchID: matchID,
            success: { (roundsFull) in
                success(roundsFull)
                
            }, fail: { (error) in
                failure(error)
            }
        )
    }
    
    func getRound(ForMatchID matchID: Int!, andRoundID roundID: Int!, success: @escaping (_ roundFull: RoundFull) -> Void, fail failure: @escaping (_ error: Error?) -> Void) {
        guard let authToken = userSessionManager.getAuthToken() else {
            failure(DochaRequestError.authTokenNotFound)
            return
        }
        
        roundRequest = RoundRequest()
        roundRequest?.getRound(withAuthToken: authToken, ForMatchID: matchID, andRoundID: roundID,
            success: { (roundFull) in
                
                self.currentRound = roundFull as RoundFull
                success(roundFull)
                
            }, fail: { (error) in
                failure(error)
            }
        )
    }
    
    func putRound(withData data: [String: Any]!, ForMatchID matchID: Int!, andRoundID roundID: Int!, success: @escaping (_ roundFull: RoundFull) -> Void, fail failure: @escaping (_ error: Error?) -> Void) {
        guard let authToken = userSessionManager.getAuthToken() else {
            failure(DochaRequestError.authTokenNotFound)
            return
        }
        
        roundRequest = RoundRequest()
        roundRequest?.putRound(withAuthToken: authToken, withData: data, ForMatchID: matchID, andRoundID: roundID,
            success: { (roundFull) in
                
                self.currentRound = roundFull as RoundFull
                self.getMatch(withMatchID: matchID,
                    success: { (_) in
                        success(roundFull)
                        
                    }, fail: { (error) in
                        failure(error)
                    }
                )
                
            }, fail: { (error) in
                failure(error)
            }
        )
    }
    
    
//MARK: Search Friends Requests
    
    func findPlayer(byPseudo pseudo: String!, success: @escaping (_ players: [Player]) -> Void, fail failure: @escaping (_ error: Error?) -> Void) {
        guard let authToken = userSessionManager.getAuthToken() else {
            failure(DochaRequestError.authTokenNotFound)
            return
        }
        
        searchRequest = SearchRequest()
        searchRequest?.findPlayer(withAuthToken: authToken, byPseudo: pseudo,
            success: { (players) in
                success(players)
                
            }, fail: { (error) in
                failure(error)
            }
        )
    }
    
    func getQuickPlayers(byOrder order: String!, andLimit limit: UInt!, success: @escaping (_ players: [Player]) -> Void, fail failure: @escaping (_ error: Error?) -> Void) {
        guard let authToken = userSessionManager.getAuthToken() else {
            failure(DochaRequestError.authTokenNotFound)
            return
        }
        
        searchRequest = SearchRequest()
        searchRequest?.getQuickPlayers(withAuthToken: authToken, byOrder: order, andLimit: limit,
            success: { (players) in
                success(players)
                
            }, fail: { (error) in
                failure(error)
            }
        )
    }
    
    func getFacebookFriends(success: @escaping (_ players: [Player]) -> Void, fail failure: @escaping (_ error: Error?) -> Void) {
        guard let authToken = userSessionManager.getAuthToken() else {
            failure(DochaRequestError.authTokenNotFound)
            return
        }
        
        searchRequest = SearchRequest()
        searchRequest?.getFacebookFriends(withAuthToken: authToken,
            success: { (friends) in
                success(friends)
                
            }, fail: { (error) in
                failure(error)
            }
        )
    }
    
    
// MARK: Ranking Requests
    
    func getGeneralRanking(success: @escaping (_ players: [Player]) -> Void, fail failure: @escaping (_ error: Error?) -> Void) {
        guard let authToken = userSessionManager.getAuthToken() else {
            failure(DochaRequestError.authTokenNotFound)
            return
        }
        
        searchRequest = SearchRequest()
        searchRequest?.getGeneralRanking(withAuthToken: authToken,
            success: { (players) in
                success(players)
                
            }, fail: { (error) in
                failure(error)
            }
        )
    }
}
