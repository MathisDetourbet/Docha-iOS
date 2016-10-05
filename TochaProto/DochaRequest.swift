//
//  DochaRequest.swift
//  Docha
//
//  Created by Mathis D on 25/07/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation
import Alamofire

enum DochaRequestError: Error {
    case notAuthenticated // Invalid token, absent, user need to be reconnected
    case serverError
    case userDefaultsNotFound
    case authTokenNotFound
    case categoryNotFound
}

class DochaRequest {
    var alamofireManager: Alamofire.SessionManager?
    let REQUEST_TIME_OUT: TimeInterval = 20.0
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = REQUEST_TIME_OUT
        configuration.httpCookieAcceptPolicy = .never
        configuration.httpShouldSetCookies = false
        alamofireManager = Alamofire.SessionManager(configuration: configuration)
    }
}

class AccessTokenAdapter: RequestAdapter {
    private let accessToken: String
    
    init(accessToken: String) {
        self.accessToken = accessToken
    }
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        urlRequest.setValue("token " + accessToken, forHTTPHeaderField: "Authorization")
        
        return urlRequest
    }
}
