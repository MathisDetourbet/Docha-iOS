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
    
    func inscriptionWithDicoParameters(dicoParameters: Dictionary<String, AnyObject>) {
        
        Alamofire.request(.POST, "http://localhost:3000/users", parameters: dicoParameters, encoding: .JSON)
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
                                    var dicoUser = [String: AnyObject]()
                                    
                                    for (key, value) : (String, JSON) in jsonReponse {
                                        dicoUser[key] = value.object
                                    }
                                    UserStateManager.sharedInstance.userState?.initPropertiesWithResponseObject(dicoUser)
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
