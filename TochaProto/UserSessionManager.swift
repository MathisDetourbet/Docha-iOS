//
//  UserSessionManager.swift
//  DochaProto
//
//  Created by Mathis D on 20/05/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

class UserSessionManager {
	
    var connexionRequest: ConnexionRequest?
    var inscriptionRequest: InscriptionRequest?
    var dicoUserDataInscription: [String: AnyObject]?
    
    class var sharedInstance: UserSessionManager {
        struct Singleton {
            static let instance = UserSessionManager()
        }
        return Singleton.instance
    }
	
    func currentSession() -> UserSession {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let connexionEncodedObject = userDefaults.objectForKey(Constants.UserDefaultsKey.kUserSessionObject) as? NSData {
            let currentSession = NSKeyedUnarchiver.unarchiveObjectWithData(connexionEncodedObject) as! UserSession
            return currentSession
        }
        
        return UserSession()
    }
    
    func isLogged() -> Bool {
        return NSUserDefaults.standardUserDefaults().objectForKey(Constants.UserDefaultsKey.kUserSessionObject) != nil
    }
    
    // Email inscription
    func inscriptionEmail(dicoParams: [String:AnyObject], success: () -> Void, fail failure: (error: NSError?, listError: [AnyObject]?) -> Void) {
        self.inscriptionRequest = InscriptionRequest()
        
        inscriptionRequest?.inscriptionWithDicoParameters(dicoParams,
            success: { (session) in
                
                // Saving user data in the device
                session.saveSession()
                success()
                
            }, fail: { (error, listErrors) in
                
        })
    }
    
    func connectByEmail(dicoParams: [String: AnyObject], success: () -> Void, fail failure: (error: NSError, listError: [AnyObject]) -> Void) {
        self.connexionRequest = ConnexionRequest()
            
        connexionRequest?.connexionWithEmail(dicoParams,
            success: {
                                                    
            }, fail: { (error, listError) in
                    
        })
    }
    
    func connectByFacebook(dicoUserData: [String:AnyObject], success: () -> Void, fail failure: (error: NSError?, listError: [AnyObject]?) -> Void) {
        self.connexionRequest = ConnexionRequest()
        
        connexionRequest?.connexionWithFacebook(dicoUserData,
            success: {
            
            }, fail: { (error, listError) in
                
        })
        
        success()
    }
    
    func connectByGooglePlus(dicoUserData: [String:AnyObject], success: () -> Void, fail failure: (error: NSError?, listError: [AnyObject]?) -> Void) {
        self.connexionRequest = ConnexionRequest()
        
        connexionRequest?.connexionWithGooglePlus(dicoUserData,
            success: {
            
            }, fail: { (error, listError) in
                
        })
    }
}
