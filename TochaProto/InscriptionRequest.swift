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

class InscriptionRequest: DochaRequest {
    
    func inscriptionEmailWithDicoParameters(dicoParameters: [String:AnyObject], success: (session: UserSessionEmail) -> Void, fail failure: (error: NSError?, listErrors: [AnyObject]?) -> Void) {
        
        let url = "\(Constants.UrlServer.UrlBase)\(Constants.UrlServer.UrlRegister.UrlEmailRegister)"
        print("URL Request inscription : \(url)")
        
        var dicoInscriptionApi = [String:AnyObject]()
        dicoInscriptionApi["user"] = dicoParameters
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.timeoutIntervalForResource = REQUEST_TIME_OUT
        
        self.alamofireManager = Alamofire.Manager(configuration: configuration)
        self.alamofireManager!.request(.POST, url, parameters: dicoInscriptionApi, encoding: .JSON)
            .validate()
            .responseJSON { response in
                let statusCode = response.response?.statusCode // Gets HTTP status code, useful for debugging
                if let status = statusCode {
                    print("Status code : \(status)")
                }
                
                if statusCode == 422 {
                    // Email already registered !
                    let error = NSError(
                        domain: kCFErrorDomainCFNetwork as String,
                        code: 422,
                        userInfo: ["message" : "L'email a déjà été enregistrée"])
                    
                    failure(error: error, listErrors: nil)
                }
                
                if let value: AnyObject = response.result.value {
                    let jsonResponse = JSON(value)
                    print("Inscription with email json : \(jsonResponse)")
                    
                    if jsonResponse["success"].bool != nil {
                        
                        if let dicoValid = jsonResponse["data"].dictionary {
                            
                            if !dicoValid.isEmpty {
                                
                                if dicoValid["user"]!.dictionary != nil  {
                                    
                                    let session = UserSessionEmail()
                                    session.userID = jsonResponse["data"]["user"][UserDataKey.kUserID].intValue
                                    session.email = jsonResponse["data"]["user"][UserDataKey.kEmail].string
                                    session.password = dicoParameters[UserDataKey.kPassword] as? String
                                    session.authToken = jsonResponse["data"][UserDataKey.kAuthToken].string
                                    
                                    if let dateString = jsonResponse["data"]["user"][UserDataKey.kDateBirthday].string {
                                        let dateFormatter = NSDateFormatter()
                                        dateFormatter.dateFormat = "yyyy-MM-dd"
                                        session.dateBirthday = dateFormatter.dateFromString(dateString)
                                    }
                                    
                                    session.firstName = jsonResponse["data"]["user"][UserDataKey.kFirstName].string
                                    session.lastName = jsonResponse["data"]["user"][UserDataKey.kLastName].string
                                    session.categoryFavorite = jsonResponse["data"]["user"][UserDataKey.kCategoryFavorite].string
                                    session.gender = jsonResponse["data"]["user"][UserDataKey.kGender].string
                                    session.avatar = jsonResponse["data"]["user"][UserDataKey.kAvatar].string
                                    
                                    success(session: session)
                                    
                                    let signIn = jsonResponse["data"]["sign_in"].boolValue
                                    
                                    if signIn == false {
                                        let params = session.generateJSONFromUserSession()!
                                        let email = params[UserDataKey.kEmail] as? String
                                        let password = params[UserDataKey.kPassword] as? String
                                        if let email = email, password = password {
                                            UserSessionManager.sharedInstance.connectByEmail(email, andPassword: password,
                                                success: {
                                                    success(session: session)
                                            
                                                }, fail: { (error, listError) in
                                                    failure(error: error, listErrors: listError)
                                            })
                                        
                                        } else {
                                            failure(error: nil, listErrors: nil)
                                            print("Email or password are nil")
                                        }
                                    }
                                    
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
        }
    }
    
    func inscriptionFacebookWithDicoParameters(dicoParameters: [String:AnyObject], success: (session: UserSessionFacebook) -> Void, fail failure: (error: NSError?, listErrors: [AnyObject]?) -> Void) {
        
        let url = "\(Constants.UrlServer.UrlBase)\(Constants.UrlServer.UrlRegister.UrlFacebookRegister)"
        print("URL Request inscription : \(url)")
        
        var dicoInscriptionApi = [String:AnyObject]()
        dicoInscriptionApi["user"] = dicoParameters
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.timeoutIntervalForResource = REQUEST_TIME_OUT
        
        self.alamofireManager = Alamofire.Manager(configuration: configuration)
        self.alamofireManager!.request(.POST, url, parameters: dicoInscriptionApi, encoding: .JSON)
            .validate()
            .responseJSON { response in
                let statusCode = response.response?.statusCode // Gets HTTP status code, useful for debugging
                if let status = statusCode {
                    print("Status code : \(status)")
                }
                
                if statusCode == 422 {
                    // Email already registered !
                    let error = NSError(
                        domain: kCFErrorDomainCFNetwork as String,
                        code: 422,
                        userInfo: ["message" : "L'email a déjà été enregistrée"])
                    
                    failure(error: error, listErrors: nil)
                }
                
                if let value: AnyObject = response.result.value {
                    let jsonResponse = JSON(value)
                    print(jsonResponse)
                    
                    if jsonResponse["success"].bool != nil {
                        
                        if let dicoValid = jsonResponse["data"].dictionary {
                            
                            if !dicoValid.isEmpty {
                                
                                if dicoValid["user"]!.dictionary != nil  {
                                    
                                    let session = UserSessionFacebook()
                                    session.userID = jsonResponse["data"]["user"][UserDataKey.kUserID].intValue
                                    session.email = jsonResponse["data"]["user"][UserDataKey.kEmail].string
                                    session.authToken = jsonResponse["data"][UserDataKey.kAuthToken].string
                                    
                                    if let dateString = jsonResponse["data"]["user"][UserDataKey.kDateBirthday].string {
                                        let dateFormatter = NSDateFormatter()
                                        dateFormatter.dateFormat = "yyyy-MM-dd"
                                        session.dateBirthday = dateFormatter.dateFromString(dateString)
                                    }
                                    
                                    session.firstName = jsonResponse["data"]["user"][UserDataKey.kFirstName].string
                                    session.lastName = jsonResponse["data"]["user"][UserDataKey.kLastName].string
                                    session.categoryFavorite = jsonResponse["data"]["user"][UserDataKey.kCategoryFavorite].string
                                    session.gender = jsonResponse["data"]["user"][UserDataKey.kGender].string
                                    session.avatar = jsonResponse["data"]["user"][UserDataKey.kAvatar].string
                                    
                                    success(session: session)
                                    
                                    let signIn = jsonResponse["data"]["sign_in"].boolValue
                                    
                                    if signIn == false {
                                        let params = session.generateJSONFromUserSession()!
                                        let connexionRequest = ConnexionRequest()
                                        connexionRequest.connexionWithFacebook(params,
                                            
                                            success: { (session) in
                                                success(session: session)
                                                
                                            }, fail: { (error, listErrors) in
                                                failure(error: error, listErrors: listErrors)
                                        })
                                    }
                                    
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
        }
    }
    
    func inscriptionGooglePlusWithDicoParameters(dicoParameters: [String:AnyObject], success: (session: UserSessionGooglePlus) -> Void, fail failure: (error: NSError?, listErrors: [AnyObject]?) -> Void) {
        
        let url = "\(Constants.UrlServer.UrlBase)\(Constants.UrlServer.UrlRegister.UrlGooglePlusRegister)"
        print("URL Request inscription : \(url)")
        
        var dicoInscriptionApi = [String:AnyObject]()
        dicoInscriptionApi["user"] = dicoParameters
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.timeoutIntervalForResource = REQUEST_TIME_OUT
        
        self.alamofireManager = Alamofire.Manager(configuration: configuration)
        self.alamofireManager!.request(.POST, url, parameters: dicoInscriptionApi, encoding: .JSON)
            .validate()
            .responseJSON { response in
                let statusCode = response.response?.statusCode // Gets HTTP status code, useful for debugging
                if let status = statusCode {
                    print("Status code : \(status)")
                }
                
                if statusCode == 422 {
                    // Email already registered !
                    let error = NSError(
                        domain: kCFErrorDomainCFNetwork as String,
                        code: 422,
                        userInfo: ["message" : "L'email a déjà été enregistrée"])
                    
                    failure(error: error, listErrors: nil)
                }
                
                if let value: AnyObject = response.result.value {
                    let jsonResponse = JSON(value)
                    print(jsonResponse)
                    
                    if jsonResponse["success"].bool != nil {
                        
                        if let dicoValid = jsonResponse["data"].dictionary {
                            
                            if !dicoValid.isEmpty {
                                
                                if dicoValid["user"]!.dictionary != nil  {
                                    
                                    let session = UserSessionGooglePlus()
                                    session.userID = jsonResponse["data"]["user"][UserDataKey.kUserID].intValue
                                    session.email = jsonResponse["data"]["user"][UserDataKey.kEmail].string
                                    session.authToken = jsonResponse["data"][UserDataKey.kAuthToken].string
                                    
                                    if let dateString = jsonResponse["data"]["user"][UserDataKey.kDateBirthday].string {
                                        let dateFormatter = NSDateFormatter()
                                        dateFormatter.dateFormat = "yyyy-MM-dd"
                                        session.dateBirthday = dateFormatter.dateFromString(dateString)
                                    }
                                    
                                    session.firstName = jsonResponse["data"]["user"][UserDataKey.kFirstName].string
                                    session.lastName = jsonResponse["data"]["user"][UserDataKey.kLastName].string
                                    session.categoryFavorite = jsonResponse["data"]["user"][UserDataKey.kCategoryFavorite].string
                                    session.gender = jsonResponse["data"]["user"][UserDataKey.kGender].string
                                    session.avatar = jsonResponse["data"]["user"][UserDataKey.kAvatar].string
                                    
                                    success(session: session)
                                    
                                    let signIn = jsonResponse["data"]["sign_in"].boolValue
                                    
                                    if signIn == false {
                                        let params = session.generateJSONFromUserSession()!
                                        let connexionRequest = ConnexionRequest()
                                        
                                        connexionRequest.connexionWithGooglePlus(params,
                                            success: { (session) in
                                                success(session: session)
                                                
                                            }, fail: { (error, listErrors) in
                                                failure(error: error, listErrors: listErrors)
                                        })
                                    }
                                    
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
        }
    }
}