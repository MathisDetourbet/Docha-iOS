//
//  InscriptionRequest.swift
//  DochaProto
//
//  Created by Mathis D on 17/05/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class InscriptionRequest {
    
    func inscriptionWithDicoParameters(dicoParameters: [String:AnyObject], success: (session: UserSessionEmail) -> Void, fail failure: (error: NSError, listErrors: [AnyObject]) -> Void) {
        
        let url = "\(Constants.UrlServer.UrlBase)\(Constants.UrlServer.UrlRegister.UrlEmailRegister)"
        print("URL Request inscription : \(url)")
        
        var dicoInscriptionApi = [String:AnyObject]()
        dicoInscriptionApi["user"] = dicoParameters
        
        Alamofire.request(.POST, url, parameters: dicoInscriptionApi, encoding: .JSON)
            .validate()
            .responseJSON { response in
                let statusCode = (response.response?.statusCode)!
                print("Status code : \(statusCode)")
                
                if let value: AnyObject = response.result.value {
                    let jsonReponse = JSON(value)
                    print(jsonReponse)
                    
                    if jsonReponse["success"].bool != nil {
                        
                        if let dicoValid = jsonReponse["data"].dictionary {
                            
                            if !dicoValid.isEmpty {
                                
                                if dicoValid["user"]!.dictionary != nil  {
                                    
                                    let session = UserSessionEmail()
                                    session.sessionID = jsonReponse["data"]["user"]["id"].intValue
                                    session.email = jsonReponse["data"]["user"]["email"].string
                                    session.password = jsonReponse["data"]["user"]["password"].string
                                    session.authToken = jsonReponse["data"]["auth_token"].string
                                    
                                    let dateFormatter = NSDateFormatter()
                                    dateFormatter.dateFormat = "dd-MM-yyyy"
                                    let dateString = jsonReponse["data"]["user"]["date_birthday"].string
                                    session.dateBirthday = dateFormatter.dateFromString(dateString!)
                                    
                                    session.firstName = jsonReponse["data"]["user"]["first_name"].string
                                    session.lastName = jsonReponse["data"]["user"]["last_name"].string
                                    session.categoryFavorite = jsonReponse["data"]["user"]["category_favorite"].string
                                    session.gender = jsonReponse["data"]["user"]["sexe"].string
                                    
                                    success(session: session)
                                    
                                } else {
                                    // JSON doesn't contain the key "user"
                                    print("json doesn't contain the key 'user'")
                                }
                            } else {
                                // JSON['data'] dictionary is empty
                                print("JSON['data'] dictionary is empty")
                            }
                        } else {
                            // JSON['data'] doesn't exist
                            print("JSON['data'] doesn't exist")
                        }
                    } else {
                        // Request failed
                        print("Request failed : \(jsonReponse["json"]["message"])")
                    }
                } else {
                    // JSON value is nil
                    print("JSON value is nil")
                }
        }
    }
}
