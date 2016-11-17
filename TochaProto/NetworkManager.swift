//
//  NetworkManager.swift
//  Docha
//
//  Created by Mathis D on 17/11/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
	
    var alamofireManager: Alamofire.SessionManager?
    var currentRequest: Alamofire.Request?
    
    class var sharedInstance: NetworkManager {
        struct Singleton {
            static let instance = NetworkManager()
        }
        return Singleton.instance
    }
    
    func suspendCurrentRequest() {
        currentRequest?.suspend()
    }
	
    func cancelCurrentRequest() {
        currentRequest?.cancel()
    }
    
    func cancelAllRequests() {
        alamofireManager?.session.getAllTasks { tasks in
            tasks.forEach { $0.cancel() }
        }
    }
}
