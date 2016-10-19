//
//  SearchRequest.swift
//  Docha
//
//  Created by Mathis D on 18/10/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class SearchRequest: DochaRequest {
    
    func findPlayer(withAuthToken authToken: String!, byPseudo pseudo: String!, success: @escaping (_ players: [Player]) -> Void, fail failure: @escaping (_ error: Error?) -> Void) {
        
        let urlString = Constants.UrlServer.UrlBase + Constants.UrlServer.UrlSearch.UrlSearchPlayerByPseudo
        debugPrint("URL POST Find Player : \(urlString)")
        
        let parameters: Parameters = [UserDataKey.kUsername: pseudo]
        
        alamofireManager!.adapter = AccessTokenAdapter(accessToken: authToken)
        alamofireManager!.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                
                guard response.result.isSuccess else {
                    if let data = response.data {
                        print("Failure Response: \(String(data: data, encoding: String.Encoding.utf8))")
                    }
                    
                    failure(response.result.error)
                    return
                }
                
                let jsonResponse = JSON(response.result.value)
                var players: [Player] = []
                
                for playerJSON in jsonResponse.arrayValue {
                    let player = Player(jsonObject: playerJSON)
                    players.append(player)
                }
                
                success(players)
        }
        
    }
    
    func getFacebookFriends(withAuthToken authToken: String!, success: @escaping (_ friends: [Player]) -> Void, fail failure: @escaping (_ error: Error?) -> Void) {
        
        let urlString = Constants.UrlServer.UrlBase + Constants.UrlServer.UrlSearch.UrlSearchFacebookFriends
        debugPrint("URL GET Facebook Players : \(urlString)")
        
        alamofireManager!.adapter = AccessTokenAdapter(accessToken: authToken)
        alamofireManager!.request(urlString, method: .get, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                
                guard response.result.isSuccess else {
                    if let data = response.data {
                        print("Failure Response: \(String(data: data, encoding: String.Encoding.utf8))")
                    }
                    
                    failure(response.result.error)
                    return
                }
                
                let jsonResponse = JSON(response.result.value)
                var friends: [Player] = []
                
                for friendJSON in jsonResponse.arrayValue {
                    let friend = Player(jsonObject: friendJSON)
                    friends.append(friend)
                }
                
                success(friends)
        }
        
    }
}
