//
//  InscriptionRequest.swift
//  DochaProto
//
//  Created by Mathis D on 17/05/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class RegistrationRequest: DochaRequest {
    
    func registrationByEmail(withEmail email: String!, andPassword password: String!, success: @escaping (_ authToken: String) -> Void, fail failure: @escaping (_ error: Error?) -> Void) {
        
        let urlString = "\(Constants.UrlServer.UrlBase)\(Constants.UrlServer.UrlRegister.UrlEmailRegister)"
        debugPrint("URL POST Register by Email : \(urlString)")
        
        let parameters: Parameters = [UserDataKey.kEmail: email,
                                      UserDataKey.kPassword1: password,
                                      UserDataKey.kPassword2: password]
        
        alamofireManager!.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                
                guard response.result.isSuccess else {
                    if let data = response.data {
                        print("Failure Response: \(String(data: data, encoding: String.Encoding.utf8))")
                    }
                    
                    failure(response.result.error)
                    return
                }
                
                let jsonResponse = JSON(response.result.value)
                
                let authToken = jsonResponse["key"].stringValue
                debugPrint(authToken)
                success(authToken)
        }
        
    }
}
