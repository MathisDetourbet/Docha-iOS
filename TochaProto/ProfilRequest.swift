//
//  ProfilRequest.swift
//  Docha
//
//  Created by Mathis D on 24/06/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ProfilRequest {
    
    func getUserProfilWithID(userID: String!, success: (user: User) -> Void, fail failure: (error: NSError?, listErrors: [AnyObject]?) -> Void) {
        
    }
    
    func updateProfil(userDico: [String:AnyObject]!, success: (() -> Void), fail failure: (error: NSError?, listErrors: [AnyObject]?) -> Void) {
        
        let parameters = userDico
        let url = "\(Constants.UrlServer.UrlBase)\(Constants.UrlServer.UrlProfil.UrlProfilUpdate)/\(parameters["id"]!)"
        print("URL connexion with email : \(url)")
        
        Alamofire.request(.PUT, url, parameters: parameters, encoding: .JSON)
            .validate()
            .responseJSON { (response) in
                let statusCode = (response.response?.statusCode)! // Gets HTTP status code, useful for debugging
                print("Status code : \(statusCode)")
                if let value: AnyObject = response.result.value {
                    let jsonResponse = JSON(value)
                    print("Connexion with email json response : \(jsonResponse)")
                    
                    if jsonResponse["success"].bool != nil {
                        
                        if let dicoValid = jsonResponse["data"].dictionary {
                            
                            if !dicoValid.isEmpty {
                                
                                if dicoValid["user"]!.dictionary != nil  {
                                    print("Success !!!")
                                    
                                } else {
                                    // JSON doesn't contain the key "user"
                                    print("json doesn't contain the key 'user'")
                                    failure(error: nil, listErrors: nil)
                                }
                            } else {
                                // JSON['data'] dictionary is empty
                                print("JSON['data'] dictionary is empty")
                                failure(error: nil, listErrors: nil)
                            }
                        } else {
                            // JSON['data'] doesn't exist
                            print("JSON['data'] doesn't exist")
                            failure(error: nil, listErrors: nil)
                        }
                    } else {
                        // Request failed
                        print("Request failed : \(jsonResponse["json"]["message"])")
                        failure(error: nil, listErrors: nil)
                    }
                } else {
                    // JSON value is nil
                    print("Error : email already registered !")
                    failure(error: nil, listErrors: nil)
                }
        }
    }
}