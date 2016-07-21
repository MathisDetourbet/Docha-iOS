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
    
    var alamofireManager: Alamofire.Manager?
    
    func connexionWithEmail(email: String, password: String, success: (session: UserSessionEmail) -> Void, fail failure: (error: NSError?, listErrors: [AnyObject]?) -> Void) {
        
        let parameters = [UserDataKey.kEmail: email, UserDataKey.kPassword: password]
        var dicoApi = [String:AnyObject]()
        dicoApi["user"] = parameters
        
        let url = "\(Constants.UrlServer.UrlBase)\(Constants.UrlServer.UrlConnexion.UrlEmailConnexion)"
        print("URL connexion with email : \(url)")
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.timeoutIntervalForResource = 15
        
        self.alamofireManager = Alamofire.Manager(configuration: configuration)
        self.alamofireManager!.request(.POST, url, parameters: parameters, encoding: .JSON)
            .validate()
            .responseJSON { (response) in
                
                switch response.result {
                case .Success:
                    print("Validation successful")
                    let statusCode = (response.response?.statusCode)! // Gets HTTP status code, useful for debugging
                    print("Status code : \(statusCode)")
                    if let value: AnyObject = response.result.value {
                        let jsonResponse = JSON(value)
                        print("Connexion with email json response : \(jsonResponse)")
                        
                        if jsonResponse["success"].bool != nil {
                            
                            if let dicoValid = jsonResponse["data"].dictionary {
                                
                                if !dicoValid.isEmpty {
                                    
                                    if dicoValid["user"]!.dictionary != nil  {
                                        
                                        let session = UserSessionEmail()
                                        session.userID = jsonResponse["data"]["user"][UserDataKey.kUserID].intValue
                                        session.email = jsonResponse["data"]["user"][UserDataKey.kEmail].string
                                        session.password = jsonResponse["data"]["user"][UserDataKey.kPassword].string
                                        session.authToken = jsonResponse["data"][UserDataKey.kAuthToken].string
                                        
                                        if let dateString = jsonResponse["data"]["user"][UserDataKey.kDateBirthday].string {
                                            let dateFormatter = NSDateFormatter()
                                            dateFormatter.dateFormat = "yyyy-MM-dd"
                                            session.dateBirthday = dateFormatter.dateFromString(dateString)
                                        }
                                        
                                        session.username = jsonResponse["data"]["user"][UserDataKey.kUsername].string
                                        session.firstName = jsonResponse["data"]["user"][UserDataKey.kFirstName].string
                                        session.lastName = jsonResponse["data"]["user"][UserDataKey.kLastName].string
                                        session.categoryFavorite = jsonResponse["data"]["user"][UserDataKey.kCategoryFavorite].string
                                        session.gender = jsonResponse["data"]["user"][UserDataKey.kGender].string
                                        session.avatar = jsonResponse["data"]["user"][UserDataKey.kAvatar].string
                                        
                                        success(session: session)
                                        
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
                    
                case .Failure(let error):
                    print(error)
                    failure(error: error, listErrors: nil)
                }
        }
    }
    
    func connexionWithFacebook(dicoParameters: [String:AnyObject]!, success: (session: UserSessionFacebook) -> Void, fail failure: (error: NSError?, listErrors: [AnyObject]?) -> Void) {
        
        var dicoApi = [String:AnyObject]()
        dicoApi["user"] = dicoParameters
        
        let url = "\(Constants.UrlServer.UrlBase)\(Constants.UrlServer.UrlConnexion.UrlFacebookConnexion)"
        print("URL connexion with Facebook : \(url)")
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.timeoutIntervalForResource = 15
        
        self.alamofireManager = Alamofire.Manager(configuration: configuration)
        self.alamofireManager!.request(.POST, url, parameters: dicoApi, encoding: .JSON, headers: nil)
            .validate()
            .responseJSON { (response) in
                
                switch response.result {
                case .Success:
                    print("Validation successful")
                    if let statusCode = (response.response?.statusCode) {
                        print("Status code : \(statusCode)")
                        
                        if let value: AnyObject = response.result.value {
                            let jsonResponse = JSON(value)
                            print("Response json : \(jsonResponse)")
                            
                            if jsonResponse["success"].bool != nil {
                                
                                if let dicoValid = jsonResponse["data"].dictionary {
                                    
                                    if !dicoValid.isEmpty {
                                        
                                        if dicoValid["user"]!.dictionary != nil {
                                            
                                            let session = UserSessionFacebook()
                                            session.userID = jsonResponse["data"]["user"][UserDataKey.kUserID].intValue
                                            session.email = jsonResponse["data"]["user"][UserDataKey.kEmail].string
                                            session.authToken = jsonResponse["data"]["user"][UserDataKey.kAuthToken].string
                                            
                                            if let dateString = jsonResponse["data"]["user"][UserDataKey.kDateBirthday].string {
                                                let dateFormatter = NSDateFormatter()
                                                dateFormatter.dateFormat = "yyyy-MM-dd"
                                                session.dateBirthday = dateFormatter.dateFromString(dateString)
                                            }
                                            
                                            session.username = jsonResponse["data"]["user"][UserDataKey.kUsername].string
                                            session.firstName = jsonResponse["data"]["user"][UserDataKey.kFirstName].string
                                            session.lastName = jsonResponse["data"]["user"][UserDataKey.kLastName].string
                                            session.categoryFavorite = jsonResponse["data"]["user"][UserDataKey.kCategoryFavorite].string
                                            session.gender = jsonResponse["data"]["user"][UserDataKey.kGender].string
                                            session.facebookImageURL = jsonResponse["data"]["user"][UserDataKey.kFacebookImageURL].string
                                            session.facebookID = jsonResponse["data"]["user"][UserDataKey.kFacebookID].string
                                            session.facebookAccessToken = jsonResponse["data"]["user"][UserDataKey.kFacebookToken].string
                                            session.dochos = jsonResponse["data"]["user"][UserDataKey.kDochos].intValue
                                            session.experience = jsonResponse["data"]["user"][UserDataKey.kExperience].intValue
                                            session.levelMaxUnlocked = jsonResponse["data"]["user"][UserDataKey.kLevelMaxUnlocked].intValue
                                            session.perfectPriceCpt = jsonResponse["data"]["user"][UserDataKey.kPerfectPriceCpt].intValue
                                            
                                            success(session: session)
                                            
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
                                // success = false
                            }
                        }
                    }

                case .Failure(let error):
                    print(error)
                    failure(error: error, listErrors: nil)
                }
        }
    }
    
    func connexionWithGooglePlus(dicoParameters: [String:AnyObject], success: (session: UserSessionGooglePlus) -> Void, fail failure: (error: NSError?, listErrors: [AnyObject]?) -> Void) {
        
        var dicoApi = [String:AnyObject]()
        dicoApi["user"] = dicoParameters
        
        let url = "\(Constants.UrlServer.UrlBase)\(Constants.UrlServer.UrlConnexion.UrlGooglePlusConnexion)"
        print("URL connexion with GooglePlus : \(url)")
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.timeoutIntervalForResource = 15
        
        self.alamofireManager = Alamofire.Manager(configuration: configuration)
        self.alamofireManager!.request(.POST, url, parameters: dicoApi, encoding: .JSON, headers: nil)
            .validate()
            .responseJSON { (response) in
                
                switch response.result {
                case .Success:
                    print("Validation successful")
                    let statusCode = (response.response?.statusCode)!
                    print("Status code : \(statusCode)")
                    
                    if let value: AnyObject = response.result.value {
                        let jsonResponse = JSON(value)
                        print("Response json : \(jsonResponse)")
                        
                        if jsonResponse["success"].bool != nil {
                            
                            if let dicoValid = jsonResponse["data"].dictionary {
                                
                                if !dicoValid.isEmpty {
                                    
                                    if dicoValid["user"]!.dictionary != nil {
                                        
                                        let session = UserSessionGooglePlus()
                                        session.userID = jsonResponse["data"]["user"][UserDataKey.kUserID].intValue
                                        session.email = jsonResponse["data"]["user"][UserDataKey.kEmail].string
                                        session.authToken = jsonResponse["data"][UserDataKey.kAuthToken].string
                                        
                                        if let dateString = jsonResponse["data"]["user"][UserDataKey.kDateBirthday].string {
                                            let dateFormatter = NSDateFormatter()
                                            dateFormatter.dateFormat = "yyyy-MM-dd"
                                            session.dateBirthday = dateFormatter.dateFromString(dateString)
                                        }
                                        
                                        session.username = jsonResponse["data"]["user"][UserDataKey.kUsername].string
                                        session.firstName = jsonResponse["data"]["user"][UserDataKey.kFirstName].string
                                        session.lastName = jsonResponse["data"]["user"][UserDataKey.kLastName].string
                                        session.categoryFavorite = jsonResponse["data"]["user"][UserDataKey.kCategoryFavorite].string
                                        session.gender = jsonResponse["data"]["user"][UserDataKey.kGender].string
                                        session.avatar = jsonResponse["data"]["user"][UserDataKey.kAvatar].string
                                        
                                        success(session: session)
                                        
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
                            // success = false
                        }
                    }
                    
                case .Failure(let error):
                    print(error)
                    failure(error: error, listErrors: nil)
                }
        }
    }
    
    func disconnectUserSession(dicoParameters: [String: AnyObject], success: ((Void) -> Void), fail failure: (error: NSError?, listErrors: [AnyObject]?) -> Void) {
        
        let url = "\(Constants.UrlServer.UrlBase)\(Constants.UrlServer.UrlConnexion.UrlLogOut)"
        print("URL Logout : \(url)")
        
        let dicoApi: [String: AnyObject] = ["user": dicoParameters]
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.timeoutIntervalForResource = 15
        
        self.alamofireManager = Alamofire.Manager(configuration: configuration)
        self.alamofireManager!.request(.DELETE, url, parameters: dicoApi, encoding: .JSON, headers: nil)
            .validate()
            .responseJSON { (response) in
                switch (response.result) {
                case .Success:
                    success()
                case .Failure(let error):
                    print(error)
                    failure(error: error, listErrors: nil)
                }
        }
    }
}
