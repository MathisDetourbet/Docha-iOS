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
    
    func connexionWithEmail(email: String, andPassword password: String) {
        
        let parameters = ["email": email, "password": password]
        
        Alamofire.request(.POST, Constants.UrlServer.UrlConnexion.UrlEmailConnexion, parameters: parameters, encoding: .JSON)
            .validate()
            .responseJSON { (response) in
                let statusCode = (response.response?.statusCode)! //Gets HTTP status code, useful for debugging
                print("Status code : \(statusCode)")
                
                if let value: AnyObject = response.result.value {
                    //Handle the results as JSON
                    let jsonReponse = JSON(value)
                    print(jsonReponse)
                    
                    let userSessionEmail = UserSessionEmail()
                    
                    
                    userSessionEmail.saveSession()
                }
        }
    }
    
    func connexionWithFacebook(dicoParameters: [String:AnyObject]) {
        
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
    
    func connexionWithGooglePlus(dicoParameters: [String:AnyObject]) {
        
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
