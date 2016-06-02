//
//  ConnexionRequest.swift
//  DochaProto
//
//  Created by Mathis D on 17/05/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ConnexionRequest {
    
    func connexionWithEmail(dicoParams: [String:AnyObject]!, success: () -> Void, fail failure: (error: NSError?, listError: [AnyObject]?) -> Void) {
        
        let parameters = ["email": dicoParams["email"]!, "password": dicoParams["password"]!]
//        let headers = [
//            "X-API-KEY": "\(dicoParams["auth_token"])",
//            "Content-type application":"json",
//            "Accept application" : "json"
//        ]
        let url = "\(Constants.UrlServer.UrlBase)\(Constants.UrlServer.UrlConnexion.UrlEmailConnexion)"
        print("URL connexion with email : \(url)")
        
        Alamofire.request(.POST, url, parameters: parameters, encoding: .JSON)
            .validate()
            .responseJSON { (response) in
                let statusCode = (response.response?.statusCode)! // Gets HTTP status code, useful for debugging
                print("Status code : \(statusCode)")
                
                if let value: AnyObject = response.result.value {
                    // Handle the results as JSON
                    let jsonReponse = JSON(value)
                    print(jsonReponse)
                    
                    let userSessionEmail = UserSessionEmail()
                    
                    
                    userSessionEmail.saveSession()
                    
                    success()
                } else {
                    //failure(error: ErrorType, listError: <#T##[AnyObject]?#>)
                }
        }
    }
    
    func connexionWithFacebook(dicoParameters: [String:AnyObject], success: () -> Void, fail failure: (error: NSError?, listError: [AnyObject]?) -> Void) {
        
        Alamofire.request(.POST, Constants.UrlServer.UrlConnexion.UrlFacebookConnexion, parameters: dicoParameters, encoding: .JSON)
        .validate()
        .responseJSON { (response) in
            
            let statusCode = (response.response?.statusCode)!
            print("Status code : \(statusCode)")
            
            if let value: AnyObject = response.result.value {
                let jsonResponse = JSON(value)
                print("Response json : \(jsonResponse)")
                
                let userSessionFb = UserSessionFacebook()
                
                
                userSessionFb.saveSession()
            }
        }
    }
    
    func connexionWithGooglePlus(dicoParameters: [String:AnyObject], success: () -> Void, fail failure: (error: NSError?, listError: [AnyObject]?) -> Void) {
        
        Alamofire.request(.POST, Constants.UrlServer.UrlConnexion.UrlGooglePlusConnexion, parameters: dicoParameters, encoding: .JSON)
        .validate()
            .responseJSON { (response) in
                
                let statusCode = (response.response?.statusCode)!
                print("Status code : \(statusCode)")
                
                if let value: AnyObject = response.result.value {
                    let jsonResponse = JSON(value)
                    print("Response json : \(jsonResponse)")
                    
                    let userSessionGooglePlus = UserSessionGooglePlus()
                    
                    
                    userSessionGooglePlus.saveSession()
                }
        }
    }
}
