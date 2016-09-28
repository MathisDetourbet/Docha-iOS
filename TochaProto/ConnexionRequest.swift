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
    
    func connexionWithEmail(_ email: String, password: String, success: @escaping (_ session: UserSessionEmail) -> Void, fail failure: @escaping (_ error: NSError?, _ listErrors: [AnyObject]?) -> Void) {
        
        let parameters = [UserDataKey.kEmail: email, UserDataKey.kPassword: password]
        var dicoApi = [String:AnyObject]()
        dicoApi["user"] = parameters as AnyObject?
        
        let urlString = "\(Constants.UrlServer.UrlBase)\(Constants.UrlServer.UrlConnexion.UrlEmailConnexion)"
        print("URL connexion with email : \(urlString)")
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = REQUEST_TIME_OUT
        
        alamofireManager = Alamofire.SessionManager(configuration: configuration)
        alamofireManager!.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate { request, response, data in
                return .success
            }
            .responseJSON { response in
                debugPrint(response)
                let jsonResponse = JSON(response)
                debugPrint(jsonResponse)
            }
        
    }
    
    func connexionWithFacebook(token accessToken: String!, success: @escaping (_ session: UserSessionFacebook) -> Void, fail failure: @escaping (_ error: NSError?, _ listErrors: [AnyObject]?) -> Void) {
        
        let urlString = "\(Constants.UrlServer.UrlBase)\(Constants.UrlServer.UrlConnexion.UrlFacebookConnexion)"
        print("URL connexion with Facebook : \(urlString)")
        
        let parameters: Parameters = [UserDataKey.kFacebookToken: accessToken!]
        print("access_token_fb : \(accessToken)")
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = REQUEST_TIME_OUT
        
        alamofireManager = Alamofire.SessionManager(configuration: configuration)
        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate { request, response, data in
                return .success
            }
            .responseJSON { response in
                debugPrint(response)
                let jsonResponse = JSON(response.result.value)
                debugPrint(jsonResponse)
                if let authToken = jsonResponse["key"].string {
                    debugPrint(authToken)
                    
                } else {
                    
                }
        }
    }
    
    func disconnectUserSession(_ dicoParameters: [String: AnyObject], success: @escaping ((Void) -> Void), fail failure: @escaping (_ error: NSError?, _ listErrors: [AnyObject]?) -> Void) {
        
        let urlString = "\(Constants.UrlServer.UrlBase)\(Constants.UrlServer.UrlConnexion.UrlLogOut)"
        print("URL Logout : \(urlString)")
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = REQUEST_TIME_OUT
        
        alamofireManager = Alamofire.SessionManager(configuration: configuration)
        alamofireManager!.request(urlString, method: .post, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { (response) in
                switch (response.result) {
                case .success:
                    success()
                case .failure(let error):
                    print(error)
                    failure(error as NSError?, nil)
                }
        }
    }
}
