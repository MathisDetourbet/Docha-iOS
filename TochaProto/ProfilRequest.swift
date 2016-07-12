//
//  ProfilRequest.swift
//  Docha
//
//  Created by Mathis D on 24/06/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ProfilRequest {
    
    func getUserProfilWithID(userID: String!, success: (user: User) -> Void, fail failure: (error: NSError?, listErrors: [AnyObject]?) -> Void) {
        
    }
    
    func updateProfil(userDico: [String:AnyObject]!, success: (() -> Void), fail failure: (error: NSError?, listErrors: [AnyObject]?) -> Void) {
        
        let parameters = userDico
        let url = "\(Constants.UrlServer.UrlBase)\(Constants.UrlServer.UrlProfil.UrlProfilUpdate)/\(parameters["id"]!).json"
        print("URL PUT Update Profil : \(url)")
        
        Alamofire.request(.PUT, url, parameters: parameters, encoding: .JSON)
            .validate()
            .responseJSON { (response) in
                let statusCode = (response.response?.statusCode)! // Gets HTTP status code, useful for debugging
                print("Status code : \(statusCode)")
                if let value: AnyObject = response.result.value {
                    let jsonResponse = JSON(value)
                    if jsonResponse["success"].bool != nil {
                        
                        if let dicoValid = jsonResponse["data"].dictionary {
                            
                            if !dicoValid.isEmpty {
                                
                                if dicoValid["user"]!.dictionary != nil  {
                                    
                                    let session = UserSessionManager.sharedInstance.currentSession()!
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
                                    session.dochos = jsonResponse["data"]["user"][UserDataKey.kDochos].intValue
                                    session.experience = jsonResponse["data"]["user"][UserDataKey.kExperience].intValue
                                    session.levelMaxUnlocked = jsonResponse["data"]["user"][UserDataKey.kLevelMaxUnlocked].intValue
                                    session.perfectPriceCpt = jsonResponse["data"]["user"][UserDataKey.kPerfectPriceCpt].intValue
                                    
                                    session.saveSession()
                                    
                                    success()
                                    
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
                        failure(error: nil, listErrors: nil)
                    }
                } else {
                    // User need to be authenticated
                    if statusCode == 401 {
                        let userSession = UserSessionManager.sharedInstance.currentSession()!.generateJSONFromUserSession()!
                        let request = ConnexionRequest()
                        request.connexionWithFacebook(userSession, success: { (session) in
                            print("success Login facebook identification !")
                            self.updateProfil(userSession,
                                success: {
                                    success()
                                }, fail: { (error, listErrors) in
                                    failure(error: nil, listErrors: nil)
                            })
                            }, fail: { (error, listErrors) in
                                print("Fail authentification test")
                                failure(error: nil, listErrors: nil)
                        })
                    } else {
                        failure(error: nil, listErrors: nil)
                    }
                }
        }
    }
}