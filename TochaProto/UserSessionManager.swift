 //
//  UserSessionManager.swift
//  DochaProto
//
//  Created by Mathis D on 20/05/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import GoogleSignIn

class UserSessionManager {
	
    var connexionRequest: ConnexionRequest?
    var inscriptionRequest: InscriptionRequest?
    var profilRequest: ProfilRequest?
    var dicoUserDataInscription: [String: AnyObject]?
    var needsToUpdateHome: Bool = false
    
    class var sharedInstance: UserSessionManager {
        struct Singleton {
            static let instance = UserSessionManager()
        }
        return Singleton.instance
    }
	
    func currentSession() -> UserSession? {
        let currentSession: UserSession?
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let connexionEncodedObject = userDefaults.objectForKey(Constants.UserDefaultsKey.kUserSessionObject) as? NSData
        
        if (connexionEncodedObject != nil) {
            currentSession = NSKeyedUnarchiver.unarchiveObjectWithData(connexionEncodedObject!) as? UserSession
        } else {
            return nil
        }
        
        return currentSession
    }
    
    func isLogged() -> Bool {
        return NSUserDefaults.standardUserDefaults().objectForKey(Constants.UserDefaultsKey.kUserSessionObject) != nil
    }
    
    
// MARK: Inscription Methods
    
    // Email inscription
    func inscriptionEmail(dicoParams: [String:AnyObject], success: () -> Void, fail failure: (error: NSError?, listError: [AnyObject]?) -> Void) {
        self.inscriptionRequest = InscriptionRequest()
        
        inscriptionRequest?.inscriptionEmailWithDicoParameters(dicoParams,
            success: { (session) in
                // Saving user data in the device
                session.saveSession()
                
                if UserSessionManager.sharedInstance.isLogged() {
                    success()
                } else {
                    let error = NSError(domain: kCFErrorFilePathKey as String, code: 900, userInfo: ["message" : "Error when exctracting user in the user defaults"])
                    failure(error: error, listError: nil)
                }
                
            }, fail: { (error, listErrors) in
                failure(error: error, listError: listErrors)
        })
    }
    
    func inscriptionByFacebook(dicoParams: [String:AnyObject], success: (session: UserSessionFacebook) -> Void, fail failure: (error: NSError?, listError: [AnyObject]?) -> Void) {
        self.inscriptionRequest = InscriptionRequest()
        
        inscriptionRequest?.inscriptionFacebookWithDicoParameters(dicoParams,
            success: { (session) in
                
                session.facebookID = dicoParams[UserDataKey.kFacebookID] as? String
                session.facebookAccessToken = dicoParams[UserDataKey.kFacebookToken] as? String
                
                session.saveSession()
                
                if UserSessionManager.sharedInstance.isLogged() {
                    success(session: session)
                } else {
                    let error = NSError(domain: kCFErrorFilePathKey as String, code: 900, userInfo: ["message" : "Error when exctracting user in the user defaults"])
                    failure(error: error, listError: nil)
                }
            
            }, fail: { (error, listErrors) in
                failure(error: error, listError: listErrors)
        })
    }
    
    func inscriptionByGooglePlus(dicoParams: [String:AnyObject], success: (session: UserSessionGooglePlus) -> Void, fail failure: (error: NSError?, listError: [AnyObject]?) -> Void) {
        self.inscriptionRequest = InscriptionRequest()
        
        inscriptionRequest?.inscriptionGooglePlusWithDicoParameters(dicoParams,
            success: { (session) in
                
                session.googlePlusID = dicoParams[UserDataKey.kGooglePlusID] as? String
                session.googlePlusAccessToken = dicoParams[UserDataKey.kGooglePlusToken] as? String
                
                session.saveSession()
                
                if UserSessionManager.sharedInstance.isLogged() {
                    success(session: session)
                } else {
                    let error = NSError(domain: kCFErrorFilePathKey as String, code: 900, userInfo: ["message" : "Error when exctracting user in the user defaults"])
                    failure(error: error, listError: nil)
                }
            
            }, fail: { (error, listErrors) in
                failure(error: error, listError: listErrors)
        })
    }
    

// MARK: Connexion Methods
    
    func signIn(success: () -> Void, fail failure: (error: NSError?, listErrors: [AnyObject]?) -> Void) {
        let userSession = self.currentSession()!
        self.connexionRequest = ConnexionRequest()
        
        if userSession.isKindOfClass(UserSessionEmail) {
            let userSessionEmail = userSession as! UserSessionEmail
            let dicoParams = userSessionEmail.generateJSONFromUserSession()
            let email = dicoParams![UserDataKey.kEmail] as? String
            let password = dicoParams![UserDataKey.kPassword] as? String
            if let email = email, password = password {
                connectByEmail(email, andPassword: password, success: { 
                    success()
                    
                    }, fail: { (error, listError) in
                    failure(error: error, listErrors: listError)
                })
            } else {
                print("Email or password are nil")
                failure(error: nil, listErrors: nil)
            }
        } else if userSession.isKindOfClass(UserSessionFacebook) {
            let userSessionEmail = userSession as! UserSessionFacebook
            let dicoParams = userSessionEmail.generateJSONFromUserSession()
            self.connexionRequest?.connexionWithFacebook(dicoParams,
                success: { (session) in
                    session.saveSession()
                    success()
                    
                }, fail: { (error, listErrors) in
                    failure(error: error, listErrors: listErrors)
            })
        }
    }
    
    func connectByEmail(email: String, andPassword password: String, success: () -> Void, fail failure: (error: NSError?, listError: [AnyObject]?) -> Void) {
        self.connexionRequest = ConnexionRequest()
            
        connexionRequest?.connexionWithEmail(email, password: password,
            success: { (session) in
                
                session.saveSession()
                
                if UserSessionManager.sharedInstance.isLogged() {
                    success()
                } else {
                    let error = NSError(domain: kCFErrorFilePathKey as String, code: 900, userInfo: ["message" : "Error when exctracting user in the user defaults"])
                    failure(error: error, listError: nil)
                }
                
            }, fail: { (error, listError) in
                failure(error: error, listError: listError)
        })
    }
    
    func connectByFacebook(dicoUserData: [String:AnyObject], success: () -> Void, fail failure: (error: NSError?, listError: [AnyObject]?) -> Void) {
        self.connexionRequest = ConnexionRequest()
        
        connexionRequest?.connexionWithFacebook(dicoUserData,
            success: { (session) in
                
                // If user have already choose his favorite category (Inscription -> facebook inscription)
                if let categoriesFavorites = UserSessionManager.sharedInstance.dicoUserDataInscription?["category_favorite"] {
                    session.categoriesFavorites = categoriesFavorites as? [String]
                }
                // Save user infos in the device
                session.saveSession()
                
                if UserSessionManager.sharedInstance.isLogged() {
                    success()
                } else {
                    let error = NSError(domain: kCFErrorFilePathKey as String, code: 900, userInfo: ["message" : "Error when exctracting user in the user defaults"])
                    failure(error: error, listError: nil)
                }
                
            }, fail: { (error, listError) in
                failure(error: error, listError: listError)
        })
    }
    
    func connectByGooglePlus(dicoUserData: [String:AnyObject], success: () -> Void, fail failure: (error: NSError?, listError: [AnyObject]?) -> Void) {
        self.connexionRequest = ConnexionRequest()
        
        connexionRequest?.connexionWithGooglePlus(dicoUserData,
            success: { (session) in
                
                session.googlePlusAccessToken = dicoUserData["gplus_token"] as? String
                session.googlePlusID = dicoUserData["gplus_id"] as? String
                session.saveSession()
                
                if UserSessionManager.sharedInstance.isLogged() {
                    success()
                } else {
                    let error = NSError(domain: kCFErrorFilePathKey as String, code: 900, userInfo: ["message" : "Error when exctracting user in the user defaults"])
                    failure(error: error, listError: nil)
                }
            
            }, fail: { (error, listErrors) in
                failure(error: error, listError: listErrors)
        })
    }
    
    func updateUserProfil(dicoParameters: [String:AnyObject], success: () -> Void, fail failure: (error: NSError?, listError: [AnyObject]?) -> Void) {
        self.profilRequest = ProfilRequest()
        
        self.profilRequest?.updateProfil(dicoParameters, success: {
            success()
            
            }, fail: { (error, listErrors) in
                failure(error: error, listError: listErrors)
        })
    }
    
    func logout() {
        if let currentSession = self.currentSession() {
            let dicoParams = currentSession.generateJSONFromUserSession()!
            self.connexionRequest = ConnexionRequest()
            self.connexionRequest!.disconnectUserSession(dicoParams,
                success: { (_) in
                    print("Logout successful")
                }, fail: { (error, listErrors) in
                    print("Logout error : \(error)")
            })
            
            if currentSession.isKindOfClass(UserSessionFacebook) {
                let loginManager = FBSDKLoginManager()
                loginManager.logOut()
                
            } else if currentSession.isKindOfClass(UserSessionGooglePlus) {
                GIDSignIn.sharedInstance().disconnect()
            }
            
            currentSession.deleteSession()
            currentSession.deleteProfilImage()
        }
    }
}
