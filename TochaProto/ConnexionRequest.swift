//
//  ConnexionRequest.swift
//  DochaProto
//
//  Created by Mathis D on 17/05/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ConnexionRequest: DochaRequest {
    
    func connexionWithEmail(_ email: String, password: String, success: @escaping (_ authToken: String) -> Void, fail failure: @escaping (_ error: Error?) -> Void) {
        
        let parameters: Parameters = [UserDataKey.kUsername: email,
                                      UserDataKey.kPassword: password]
        
        let urlString = Constants.UrlServer.UrlBase + Constants.UrlServer.UrlConnexion.UrlEmailConnexion
        debugPrint("URL connexion with email : \(urlString)")
        
        alamofireManager!.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                let jsonResponse = JSON(response.result.value)
                let authToken = jsonResponse[UserDataKey.kAuthToken].string
                
                guard response.result.isSuccess, let _ = authToken else {
                    if let data = response.data {
                        print("Failure Response: \(String(data: data, encoding: String.Encoding.utf8))")
                    }
                    
                    failure(response.result.error)
                    return
                }
                
                success(authToken!)
        }
    }
    
    func connexionWithFacebook(withFacebookToken accessToken: String!, success: @escaping (_ authToken: String) -> Void, fail failure: @escaping (_ error: Error?) -> Void) {
        
        let urlString = Constants.UrlServer.UrlBase + Constants.UrlServer.UrlConnexion.UrlFacebookConnexion
        debugPrint("URL connexion with Facebook : \(urlString)")
        
        let parameters: Parameters! = [UserDataKey.kFacebookToken: accessToken!]
        
        alamofireManager!.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                let jsonResponse = JSON(response.result.value)
                let authToken = jsonResponse[UserDataKey.kAuthToken].string
                
                guard response.result.isSuccess, let _ = authToken  else {
                    if let data = response.data {
                        print("Failure Response: \(String(data: data, encoding: String.Encoding.utf8))")
                    }
                    
                    failure(response.result.error)
                    return
                }
                
                success(authToken!)
            }
    }
    
    //Error : Connexion au serveur impossible.
    
    func logOutUser() {
        
        let urlString = Constants.UrlServer.UrlBase + Constants.UrlServer.UrlConnexion.UrlLogOut
        debugPrint("URL Logout : \(urlString)")
        
        alamofireManager!.request(urlString, method: .get, encoding: JSONEncoding.default)
            .responseJSON { _ in
                
            }
    }
}
