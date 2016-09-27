//
//  ProfilRequest.swift
//  Docha
//
//  Created by Mathis D on 24/06/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ProfilRequest: DochaRequest {
    
    func getUserProfilWithID(_ userID: String!, success: (_ user: User) -> Void, fail failure: (_ error: NSError?, _ listErrors: [AnyObject]?) -> Void) {
        
    }
    
    func updateProfil(_ userDico: [String:AnyObject]!, success: @escaping (() -> Void), fail failure: @escaping (_ error: NSError?, _ listErrors: [AnyObject]?) -> Void) {
        
        /*let parameters = userDico
        let urlString = "\(Constants.UrlServer.UrlBase)\(Constants.UrlServer.UrlProfil.UrlProfilUpdate)/\(parameters?["id"]!).json"
        print("URL PUT Update Profil : \(urlString)")
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = REQUEST_TIME_OUT
        
        alamofireManager = Alamofire.SessionManager(configuration: configuration)
        alamofireManager!.request(urlString, method: .put, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { (response) in
                let statusCode = response.response?.statusCode // Gets HTTP status code, useful for debugging
                if let status = statusCode {
                    print("Status code : \(status)")
                }
                if let value: AnyObject = response.result.value {
                    let jsonResponse = JSON(value)
                    if jsonResponse["success"].bool != nil {
                        
                        print("User updated json response : \(jsonResponse)")
                        
                        if let dicoValid = jsonResponse["data"].dictionary {
                            
                            if !dicoValid.isEmpty {
                                
                                if dicoValid["user"]!.dictionary != nil  {
                                    
                                    let session = UserSessionManager.sharedInstance.currentSession()!
                                    session.userID = jsonResponse["data"]["user"][UserDataKey.kUserID].intValue
                                    session.email = jsonResponse["data"]["user"][UserDataKey.kEmail].string
                                    session.authToken = jsonResponse["data"]["user"][UserDataKey.kAuthToken].string
                                    
                                    if let dateString = jsonResponse["data"]["user"][UserDataKey.kDateBirthday].string {
                                        let dateFormatter = DateFormatter()
                                        dateFormatter.dateFormat = "yyyy-MM-dd"
                                        session.dateBirthday = dateFormatter.date(from: dateString)
                                    }
                                    
                                    session.pseudo = jsonResponse["data"]["user"][UserDataKey.kPseudo].string
                                    session.firstName = jsonResponse["data"]["user"][UserDataKey.kFirstName].string
                                    session.lastName = jsonResponse["data"]["user"][UserDataKey.kLastName].string
                                    
                                    let categoriesFavoritesJSON = jsonResponse["data"]["user"][UserDataKey.kCategoryFavorite].array
                                    if let categoriesFavoritesJSON = categoriesFavoritesJSON {
                                        var categoriesFavorites: [String] = []
                                        for category in categoriesFavoritesJSON {
                                            categoriesFavorites.append(category.stringValue)
                                        }
                                        session.categoriesFavorites = categoriesFavorites
                                    }
                                    session.gender = jsonResponse["data"]["user"][UserDataKey.kGender].string
                                    session.dochos = jsonResponse["data"]["user"][UserDataKey.kDochos].intValue
                                    session.experience = jsonResponse["data"]["user"][UserDataKey.kExperience].intValue
                                    session.levelMaxUnlocked = jsonResponse["data"]["user"][UserDataKey.kLevelMaxUnlocked].intValue
                                    session.perfectPriceCpt = jsonResponse["data"]["user"][UserDataKey.kPerfectPriceCpt].intValue
                                    session.avatar = jsonResponse["data"]["user"][UserDataKey.kAvatar].string
                                    
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
                        if let userSession = UserSessionManager.sharedInstance.currentSession() {
                        
                            if userSession.isKind(of: UserSessionEmail.self) {
                                let params = userSession.generateJSONFromUserSession()!
                                let email = params[UserDataKey.kEmail] as? String
                                let password = params[UserDataKey.kPassword] as? String
                                if let email = email, let password = password {
                                    UserSessionManager.sharedInstance.connectByEmail(email, andPassword: password,
                                        success: {
                                            success()
                                            
                                        }, fail: { (error, listError) in
                                            failure(error: error, listErrors: listError)
                                    })
                                    
                                } else {
                                    failure(error: nil, listErrors: nil)
                                    print("Email or password are nil")
                                }
                                
                            } else if userSession.isKind(of: UserSessionFacebook.self) {
                                
                                let dicoParams = userSession.generateJSONFromUserSession()!
                                let request = ConnexionRequest()
                                request.connexionWithFacebook(dicoParams, success: { (session) in
                                    print("success Login facebook identification !")
                                    self.updateProfil(dicoParams,
                                        success: {
                                            success()
                                        }, fail: { (error, listErrors) in
                                            failure(error: nil, listErrors: nil)
                                    })
                                    }, fail: { (error, listErrors) in
                                        print("Fail authentification test")
                                        failure(error: nil, listErrors: nil)
                                })
                                
                            } else if userSession.isKind(of: UserSessionGooglePlus.self) {
                                
                                let dicoParams = userSession.generateJSONFromUserSession()!
                                let request = ConnexionRequest()
                                request.connexionWithGooglePlus(dicoParams, success: { (session) in
                                    print("success Login facebook identification !")
                                    self.updateProfil(dicoParams,
                                        success: {
                                            success()
                                        }, fail: { (error, listErrors) in
                                            failure(error: nil, listErrors: nil)
                                    })
                                    }, fail: { (error, listErrors) in
                                        print("Fail authentification test")
                                        failure(error: nil, listErrors: nil)
                                })
                            }
                        }
                        
                    } else {
                        failure(error: nil, listErrors: nil)
                    }
                }
        }
 */
    }
    
    func getUserFriendsDochaInstalled(_ facebookToken: String, success: (_ friendsList: [User]?) -> Void, fail failure: (_ error: NSError?, _ listErrors: [AnyObject]?) -> Void) {
        /*
        let parameters = [UserDataKey.kFacebookToken : facebookToken]
        let url = "\(Constants.UrlServer.UrlBase)\(Constants.UrlServer.UrlProfil.UrlGetFriendsDochaInstalled).json"
        print("URL GET FRIENDSLIST DOCHA INSTALLED : \(url)")
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = REQUEST_TIME_OUT
        
        self.alamofireManager = Alamofire.Manager(configuration: configuration)
        self.alamofireManager!.request(.POST, url, parameters: parameters, encoding: .json)
            .validate()
            .responseJSON { (response) in
                if let statusCode = response.response?.statusCode {
                    // Gets HTTP status code, useful for debugging
                    print("Status code : \(statusCode)")
                }
                if let value: AnyObject = response.result.value {
                    let jsonResponse = JSON(value)
                    if jsonResponse["success"].bool != nil {
                        let array = jsonResponse["data"]["friends"].arrayValue
                        let dico = jsonResponse["data"]["friends"].dictionaryValue
                        print(array)
                        print(dico)
                    }
                }
        }
    */
    }
}
