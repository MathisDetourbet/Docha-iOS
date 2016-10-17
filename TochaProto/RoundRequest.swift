//
//  RoundRequest.swift
//  Docha
//
//  Created by Mathis D on 10/10/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class RoundRequest: DochaRequest {
    
    func getAllRounds(withAuthToken authToken: String!, ForMatchID matchID: Int!, success: @escaping(_ roundsFull: [RoundFull]) -> Void, fail failure: @escaping(_ error: Error?) -> Void) {
    
        let urlString = Constants.UrlServer.UrlBase + Constants.UrlServer.UrlMatch.UrlGetMatch + "/" + String(matchID) + "/" + Constants.UrlServer.UrlMatch.UrlGetRounds
        debugPrint("URL GET All Rounds : \(urlString)")
        
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
                var roundsFull: [RoundFull] = []
                
                for roundJSON in jsonResponse.array! {
                    let roundFull = RoundFull(jsonObject: roundJSON)
                    roundsFull.append(roundFull)
                }
                
                success(roundsFull)
        }
    }
    
    func getRound(withAuthToken authToken: String!, ForMatchID matchID: Int!, andRoundID roundID: Int!, success: @escaping(_ roundFull: RoundFull) -> Void, fail failure: @escaping(_ error: Error?) -> Void) {
        
        let urlString = Constants.UrlServer.UrlBase + Constants.UrlServer.UrlMatch.UrlGetMatch + "/" + String(matchID) + Constants.UrlServer.UrlMatch.UrlGetRounds + "/" + String(roundID)
        debugPrint("URL GET Rounds : \(urlString)")
        
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
                let roundFull = RoundFull(jsonObject: jsonResponse)
                
                success(roundFull)
        }
    }
    
    func patchRound(withAuthToken authToken: String!, withData data: [String: Any]!, ForMatchID matchID: Int, andRoundID roundID: Int!, success: @escaping(_ roundFull: RoundFull) -> Void, fail failure: @escaping(_ error: Error?) -> Void) {
        
        let urlString = Constants.UrlServer.UrlBase + Constants.UrlServer.UrlMatch.UrlGetMatch + "/" + String(matchID) + Constants.UrlServer.UrlMatch.UrlGetRounds + "/" + String(roundID)
        debugPrint("URL PATCH Rounds : \(urlString)")
        
        alamofireManager!.adapter = AccessTokenAdapter(accessToken: authToken)
        alamofireManager!.request(urlString, method: .patch, encoding: JSONEncoding.default)
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
                let roundFull = RoundFull(jsonObject: jsonResponse)
                
                success(roundFull)
        }
    }
    
    func putRound(withAuthToken authToken: String!, withData data: [String: Any]!, ForMatchID matchID: Int, andRoundID roundID: Int!, success: @escaping(_ roundFull: RoundFull) -> Void, fail failure: @escaping(_ error: Error?) -> Void) {
        
        let urlString = Constants.UrlServer.UrlBase + Constants.UrlServer.UrlMatch.UrlGetMatch + "/" + String(matchID) + Constants.UrlServer.UrlMatch.UrlGetRounds + "/" + String(roundID)
        debugPrint("URL PUT Round : \(urlString)")
        
        let parameters: Parameters = data
        
        alamofireManager!.adapter = AccessTokenAdapter(accessToken: authToken)
        alamofireManager!.request(urlString, method: .put, parameters: parameters, encoding: JSONEncoding.default)
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
                let roundFull = RoundFull(jsonObject: jsonResponse)
                
                success(roundFull)
        }
    }
}
