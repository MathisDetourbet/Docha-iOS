//
//  UserRequest.swift
//  Docha
//
//  Created by Mathis D on 27/09/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class UserRequest: DochaRequest {
    
    func getUser(withAuthToken authToken: String!, success: @escaping (_ user: User) -> Void, fail failure: @escaping (_ error: Error?) -> Void) {
        
        let urlString = Constants.UrlServer.UrlBase + Constants.UrlServer.UrlUser.UrlUser
        debugPrint("URL GET User : \(urlString)")
        
        alamofireManager!.adapter = AccessTokenAdapter(accessToken: authToken)
        alamofireManager!.request(urlString, method: .get, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                
                guard response.result.isSuccess else {
                    failure(response.result.error)
                    return
                }
                
                let jsonResponse = JSON(response.result.value)
                let user = User()
                user.initPropertiesWithResponseObject(jsonResponse)
                debugPrint("jsonResponse :\(response.result.value)")
                success(user)
            }
    }
    
    func putUser(withAuthToken authToken: String!, andData data: [String: Any]!, success: @escaping (_ user: User) -> Void, fail failure: @escaping (_ error: Error?) -> Void) {
        
        let urlString = Constants.UrlServer.UrlBase + Constants.UrlServer.UrlUser.UrlUser
        debugPrint("URL PUT User : \(urlString)")
        
        let parameters: Parameters = [data.first!.key: data.first!.value]
        
        alamofireManager!.adapter = AccessTokenAdapter(accessToken: authToken)
        alamofireManager!.request(urlString, method: .put, parameters: parameters, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                
                guard response.result.isSuccess else {
                    failure(response.result.error)
                    return
                }
                
                let jsonResponse = JSON(response.result.value)
                let user = User()
                user.initPropertiesWithResponseObject(jsonResponse)
                
                success(user)
        }
    }
    
    func patchUser(withToken authToken: String!, andData data: [String: Any]!, success : @escaping (_ user: User) -> Void, fail failure: @escaping (_ error: Error?) -> Void) {
        
        let urlString = Constants.UrlServer.UrlBase + Constants.UrlServer.UrlUser.UrlUser
        debugPrint("URL PATCH User : \(urlString)")
        
        let parameters: Parameters = data
        
        alamofireManager!.adapter = AccessTokenAdapter(accessToken: authToken)
        alamofireManager!.request(urlString, method: .patch, parameters: parameters, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                
                guard response.result.isSuccess else {
                    failure(response.result.error)
                    return
                }
                
                let jsonResponse = JSON(response.result.value)
                let user = User()
                user.initPropertiesWithResponseObject(jsonResponse)
                
                success(user)
            }
    }
}
