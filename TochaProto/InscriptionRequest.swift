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
        
        var statusCode: Int = 0
        Alamofire.request(.POST, "http://localhost:3000/users", parameters: dicoParameters, encoding: .JSON)
            .responseJSON { response in
                statusCode = (response.response?.statusCode)!
                print("Status code : \(statusCode)")
                
                if let value: AnyObject = response.result.value {
                    let jsonReponse = JSON(value)
                    
                    if jsonReponse["success"].bool != nil {
                        if let token = jsonReponse["data"]["auth_token"].string {
                            UserStateManager.sharedInstance.userState?.authToken = token
                            UserStateManager.sharedInstance.saveUserState()
                        }
                    }
                }
        }
    }
}
