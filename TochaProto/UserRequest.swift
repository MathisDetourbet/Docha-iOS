//
//  UserRequest.swift
//  Docha
//
//  Created by Mathis D on 27/09/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class UserRequest: DochaRequest {
    
    func getUser(success: (_ user: User) -> Void, fail failure: (_ error: NSError?, _ listErrors: [AnyObject]?) -> Void) {
        
        let urlString = "\(Constants.UrlServer.UrlBase)\(Constants.UrlServer.UrlUser.UrlGetUser)"
        print("URL connexion with Facebook : \(urlString)")
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = REQUEST_TIME_OUT
        
        alamofireManager = Alamofire.SessionManager(configuration: configuration)
        alamofireManager?.adapter = AccessTokenAdapter(accessToken: "")
        alamofireManager!.request(urlString, method: .get, encoding: JSONEncoding.default)
            .validate { request, response, data in
                debugPrint("Response after validation : \(response)")
                return .success
            }
            .responseJSON { (response) in
                debugPrint("ResponseJSON : \(response)")
        }
    }
    
}

// 36a39af61aff1d3112e9258435a113eaa0eeb214
