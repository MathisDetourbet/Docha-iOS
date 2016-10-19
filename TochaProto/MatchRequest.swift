//
//  MatchRequest.swift
//  Docha
//
//  Created by Mathis D on 09/10/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MatchRequest: DochaRequest {
    
    func getAllMatch(withAuthToken authToken: String!, success: @escaping(_ matchArray: [Match]) -> Void, fail failure: @escaping(_ error: Error?) -> Void) {
        
        let urlString = Constants.UrlServer.UrlBase + Constants.UrlServer.UrlMatch.UrlGetAllMatch
        debugPrint("URL GET All Match : \(urlString)")
        
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
                
                var matchArray: [Match] = []
                for matchJSON in jsonResponse.array! {
                    let match = Match(jsonObject: matchJSON)
                    matchArray.append(match)
                }
                
                success(matchArray)
        }
    }
    
    func postMatch(withAuthToken authToken: String!, success: @escaping(_ match: Match) -> Void, fail failure: @escaping(_ error: Error?) -> Void) {
        
        let urlString = Constants.UrlServer.UrlBase + Constants.UrlServer.UrlMatch.UrlPostMatch
        debugPrint("URL POST Match : \(urlString)")
        
        alamofireManager!.adapter = AccessTokenAdapter(accessToken: authToken)
        alamofireManager!.request(urlString, method: .post, encoding: JSONEncoding.default)
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
                let match = Match(jsonObject: jsonResponse)
                success(match)
        }
    }
    
    func postMatch(withAuthToken authToken: String!, andOpponentPseudo opponentPseudo: String!, success: @escaping(_ match: Match) -> Void, fail failure: @escaping(_ error: Error?) -> Void) {
        
        let urlString = Constants.UrlServer.UrlBase + Constants.UrlServer.UrlMatch.UrlPostMatch
        debugPrint("URL POST Match with Pseudo : \(urlString)")
        
        let parameters: Parameters = [UserDataKey.kUsername: opponentPseudo]
        
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
                let match = Match(jsonObject: jsonResponse)
                success(match)
        }
    }
    
    func getMatch(withAuthToken authToken: String!, andMatchID matchID: Int!, success: @escaping(_ match: Match) -> Void, fail failure: @escaping(_ error: Error?) -> Void) {
        
        let urlString = Constants.UrlServer.UrlBase + Constants.UrlServer.UrlMatch.UrlGetMatch + "/" + String(matchID)
        debugPrint("URL GET Match : \(urlString)")
        
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
                let match = Match(jsonObject: jsonResponse)
                success(match)
        }
    }
    
    func deleteMatch(withAuthToken authToken: String!, andMatchID matchID: Int!, success: @escaping() -> Void, fail failure: @escaping(_ error: Error?) -> Void) {
        
        let urlString = Constants.UrlServer.UrlBase + Constants.UrlServer.UrlMatch.UrlGetMatch + "/" + String(matchID)
        debugPrint("URL DELETE Match : \(urlString)")
        
        alamofireManager!.adapter = AccessTokenAdapter(accessToken: authToken)
        alamofireManager!.request(urlString, method: .delete, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                
                guard response.result.isSuccess else {
                    if let data = response.data {
                        print("Failure Response: \(String(data: data, encoding: String.Encoding.utf8))")
                    }
                    
                    failure(response.result.error)
                    return
                }
                
                success()
        }
    }
}
