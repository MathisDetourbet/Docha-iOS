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
        
        let userSession = UserSession()
        userSession.saveSession()
        return userSession
    }
    
    func isLogged() -> Bool {
        return NSUserDefaults.standardUserDefaults().objectForKey(Constants.UserDefaultsKey.kUserSessionObject) != nil
    }
    
    func inscription(dicoParams: [String: AnyObject], success: () -> Void, fail failure: (error: NSError, listError: [AnyObject]) -> Void) {
        self.inscriptionRequest = InscriptionRequest()
        
        inscriptionRequest?.inscriptionWithDicoParameters(dicoParams)
    }
}
