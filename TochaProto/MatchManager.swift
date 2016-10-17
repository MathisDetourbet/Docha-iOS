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
        let image = (userData.avatarImage ?? #imageLiteral(resourceName: "avatar_man_large")).roundCornersToCircle(withBorder: 10.0, color: UIColor.white)
        let avatarUrl = userData.user?.avatarUrl ?? "avatar_man_large"
        let userPlayer = Player(pseudo: userData.user?.pseudo ?? Player.defaultPlayer().pseudo,
                                gender: Gender.universal,
                                avatarUrl: avatarUrl,
                                avatarImage: image!,
                                isDefaultPlayer: false,
                                level: userData.user?.levelMaxUnlocked ?? nil,
                                dochos: userData.user?.dochos ?? 0)
        self.userPlayer = userPlayer
        
        
        // Opponent Player
        let opponentPlayer: Player
        
        if let match = self.currentMatch {
            opponentPlayer = Player(player: match.opponent)
            
            if opponentPlayer.isDefaultPlayer! {
                opponentPlayer.avatarImage = nil
                self.opponentPlayer = opponentPlayer
                completion()
                
            } else {
                let url = URL(string: opponentPlayer.avatarUrl)
                ImageDownloader.default.downloadImage(with: url!, options: [], progressBlock: nil,
                    completionHandler: { (image, error, _, _) in
                        if error != nil {
                            debugPrint(error)
                            completion()
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
    
    
//MARK: Match Requests
	
    func getAllMatch(success: @escaping (_ matchArray: [Match]) -> Void, fail failure: @escaping (_ error: Error?) -> Void) {
        guard let authToken = userSessionManager.getAuthToken() else {
            failure(DochaRequestError.authTokenNotFound)
            return
        }
        
        matchRequest = MatchRequest()
        matchRequest?.getAllMatch(withAuthToken: authToken,
            success: { (matchArray) in
                
                success(matchArray)
                self.matchArray = matchArray
                
            }, fail: { (error) in
                failure(error)
            }
        )
    }
    
    func postMatch(success: @escaping(_ match: Match) -> Void, fail failure: @escaping(_ error: Error?) -> Void) {
        guard let authToken = userSessionManager.getAuthToken() else {
            failure(DochaRequestError.authTokenNotFound)
            return
        }
        
        matchRequest = MatchRequest()
        matchRequest?.postMatch(withAuthToken: authToken,
            success: { (match) in
                
                success(match)
                self.currentMatch = match
                
            }, fail: { (error) in
                failure(error)
            }
        )
    }
    
    func getMatch(withMatchID matchID: Int!, success: @escaping(_ match: Match) -> Void, fail failure: @escaping(_ error: Error?) -> Void) {
        guard let authToken = userSessionManager.getAuthToken() else {
            failure(DochaRequestError.authTokenNotFound)
            return
        }
        
        matchRequest = MatchRequest()
        matchRequest?.getMatch(withAuthToken: authToken, andMatchID: matchID,
            success: { (match) in
                success(match)
                self.currentMatch = match
                
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
                success(roundFull)
                
            }, fail: { (error) in
                failure(error)
            }
        )
    }
}
