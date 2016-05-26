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
        
        Alamofire.request(.POST, "http://localhost:3000/users/sign_in", parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                let statusCode = (response.response?.statusCode)! //Gets HTTP status code, useful for debugging
                print("Status code : \(statusCode)")
                
                if let value: AnyObject = response.result.value {
                    //Handle the results as JSON
                    let jsonReponse = JSON(value)
                    print(jsonReponse)
                    
                    if let sessionID = jsonReponse["session_id"].string {
                        print(sessionID)
                        //At this point the user should have authenticated, store the session id and use it as you wish
                    } else {
                        print("error detected")
                    }
                }
        }
    }
}
