//
//  UserStateManager.swift
//  DochaProto
//
//  Created by Mathis D on 01/05/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

class UserStateManager {
    
    var userState: User?
	
    class var sharedInstance: UserStateManager {
        struct Singleton {
            static let instance = UserStateManager()
        }
        return Singleton.instance
    }
    
    func loadUserState() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if ((userDefaults.objectForKey(Constants.UserDefaultsKey.kUserStateKey)) == nil) {
            // Creating new User
            self.userState = User(levelMaxUnlocked: 1, dochos: 0, experience: 0, authToken: "")
            self.saveUserState()
            
        } else {
            // Decoding user state
            let decoded = userDefaults.objectForKey(Constants.UserDefaultsKey.kUserStateKey) as! NSData
            self.userState = NSKeyedUnarchiver.unarchiveObjectWithData(decoded) as? User
        }
    }
    
    func saveUserState() {
        // Saving user state
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let encodedData = NSKeyedArchiver.archivedDataWithRootObject(self.userState!)
        userDefaults.setObject(encodedData, forKey: Constants.UserDefaultsKey.kUserStateKey)
        userDefaults.synchronize()
    }
}
