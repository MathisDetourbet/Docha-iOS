 //
//  UserSessionManager.swift
//  DochaProto
//
//  Created by Mathis D on 20/05/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
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
        let userDefaults = UserDefaults.standard
        let connexionEncodedObject = userDefaults.object(forKey: Constants.UserDefaultsKey.kUserSessionObject) as? Data
        
        if (connexionEncodedObject != nil) {
            currentSession = NSKeyedUnarchiver.unarchiveObject(with: connexionEncodedObject!) as? UserSession
        } else {
            return nil
        }
        
        return currentSession
    }
    
    func isLogged() -> Bool {
        //return NSUserDefaults.standardUserDefaults().objectForKey(Constants.UserDefaultsKey.kUserSessionObject) != nil
        return true
    }
    
    
// MARK: Inscription Methods
    
    // Email inscription
    func inscriptionEmail(_ dicoParams: [String:AnyObject], success: @escaping () -> Void, fail failure: @escaping (_ error: NSError?, _ listError: [AnyObject]?) -> Void) {
        self.inscriptionRequest = InscriptionRequest()
        
        inscriptionRequest?.inscriptionEmailWithDicoParameters(dicoParams,
            success: { (session) in
                // Saving user data in the device
                session.saveSession()
                
                if UserSessionManager.sharedInstance.isLogged() {
                    success()
                } else {
                    let error = NSError(domain: kCFErrorFilePathKey as String, code: 900, userInfo: ["message" : "Error when exctracting user in the user defaults"])
                    failure(error, nil)
                }
                
            }, fail: { (error, listErrors) in
                failure(error, listErrors)
        })
    }
    
    func inscriptionByFacebook(_ dicoParams: [String:AnyObject], success: @escaping (_ session: UserSessionFacebook) -> Void, fail failure: @escaping (_ error: NSError?, _ listError: [AnyObject]?) -> Void) {
        self.inscriptionRequest = InscriptionRequest()
        
        inscriptionRequest?.inscriptionFacebookWithDicoParameters(dicoParams,
            success: { (session) in
                
                session.facebookID = dicoParams[UserDataKey.kFacebookID] as? String
                session.facebookAccessToken = dicoParams[UserDataKey.kFacebookToken] as? String
                
                session.saveSession()
                
                if UserSessionManager.sharedInstance.isLogged() {
                    success(session)
                } else {
                    let error = NSError(domain: kCFErrorFilePathKey as String, code: 900, userInfo: ["message" : "Error when exctracting user in the user defaults"])
                    failure(error, nil)
                }
            
            }, fail: { (error, listErrors) in
                failure(error, listErrors)
        })
    }
    

// MARK: Connexion Methods
    
    func signIn(_ success: @escaping () -> Void, fail failure: @escaping (_ error: NSError?, _ listErrors: [AnyObject]?) -> Void) {
        let userSession = self.currentSession()!
        self.connexionRequest = ConnexionRequest()
        
        if userSession.isKind(of: UserSessionEmail.self) {
            let userSessionEmail = userSession as! UserSessionEmail
            let dicoParams = userSessionEmail.generateJSONFromUserSession()
            let email = dicoParams![UserDataKey.kEmail] as? String
            let password = dicoParams![UserDataKey.kPassword] as? String
            if let email = email, let password = password {
                connectByEmail(email, andPassword: password, success: { 
                    success()
                    
                    }, fail: { (error, listError) in
                    failure(error, listError)
                })
            } else {
                print("Email or password are nil")
                failure(nil, nil)
            }
        } else if userSession.isKind(of: UserSessionFacebook.self) {
            let userSessionFacebook = userSession as! UserSessionFacebook
            if let accessToken = userSessionFacebook.facebookAccessToken {
                self.connexionRequest?.connexionWithFacebook(
                    token: accessToken,
                    success: { (session) in
                        session.saveSession()
                        success()
                                                                
                    }, fail: { (error, listErrors) in
                        failure(error, listErrors)
                })
            } else {
                failure(nil, nil)
            }
        }
    }
    
    func connectByEmail(_ email: String, andPassword password: String, success: @escaping () -> Void, fail failure: @escaping (_ error: NSError?, _ listError: [AnyObject]?) -> Void) {
        self.connexionRequest = ConnexionRequest()
            
        connexionRequest?.connexionWithEmail(email, password: password,
            success: { (session) in
                
                session.saveSession()
                
                if UserSessionManager.sharedInstance.isLogged() {
                    success()
                } else {
                    let error = NSError(domain: kCFErrorFilePathKey as String, code: 900, userInfo: ["message" : "Error when exctracting user in the user defaults"])
                    failure(error, nil)
                }
                
            }, fail: { (error, listError) in
                failure(error, listError)
        })
    }
    
    func connectByFacebook(token accessToken: String!, success: @escaping () -> Void, fail failure: @escaping (_ error: NSError?, _ listError: [AnyObject]?) -> Void) {
        
        connexionRequest = ConnexionRequest()
        
        connexionRequest?.connexionWithFacebook(token: accessToken,
            success: { (session) in
                
                if UserSessionManager.sharedInstance.isLogged() {
                    success()
                } else {
                    let error = NSError(domain: kCFErrorFilePathKey as String, code: 900, userInfo: ["message" : "Error when exctracting user in the user defaults"])
                    failure(error, nil)
                }
                
            }, fail: { (error, listError) in
                failure(error, listError)
        })
    }
    
    func updateUserProfil(_ dicoParameters: [String:AnyObject], success: @escaping () -> Void, fail failure: @escaping (_ error: NSError?, _ listError: [AnyObject]?) -> Void) {
        self.profilRequest = ProfilRequest()
        
        self.profilRequest?.updateProfil(dicoParameters, success: {
            success()
            
            }, fail: { (error, listErrors) in
                failure(error, listErrors)
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
            
            if currentSession.isKind(of: UserSessionFacebook.self) {
                let loginManager = FBSDKLoginManager()
                loginManager.logOut()
            }
            
            currentSession.deleteSession()
            currentSession.deleteProfilImage()
        }
    }
}
