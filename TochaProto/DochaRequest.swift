//
//  DochaRequest.swift
//  Docha
//
//  Created by Mathis D on 25/07/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation
import Alamofire

class DochaRequest {
    var alamofireManager: Alamofire.SessionManager?
    let REQUEST_TIME_OUT: TimeInterval = 20.0
}

//class AccessTokenAdapter: RequestAdapter {
//    private let accessToken: String
//    
//    init(accessToken: String) {
//        self.accessToken = accessToken
//    }
//    
//    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
//        var urlRequest = urlRequest
//        
//        if urlRequest.url!.absoluteString.hasPrefix("https://httpbin.org") {
//            urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
//        }
//        
//        return urlRequest
//    }
//}
