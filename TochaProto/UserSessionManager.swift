 //
//  UserSessionManager.swift
//  DochaProto
//
//  Created by Mathis D on 20/05/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

class UserSessionManager {
	
    var connexionRequest: ConnexionRequest?
    var registrationRequest: RegistrationRequest?
    var userRequest: UserRequest?
    var categoryRequest: CategoryRequest?
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
        return UserDefaults.standard.object(forKey: Constants.UserDefaultsKey.kUserSessionObject) != nil
    }
    
    func getAuthToken() -> String? {
        let currentSession = self.currentSession()
        if let currentSession = currentSession {
            return currentSession.authToken ?? nil
        }
        
        return nil
    }
    
    
// MARK: Inscription Methods
    
    // Email inscription
    func registrationByEmail(_ email: String!, andPassword password: String!, success: @escaping () -> Void, fail failure: @escaping (_ error: Error?) -> Void) {
        
        registrationRequest = RegistrationRequest()
        
        registrationRequest?.registrationByEmail(withEmail: email, andPassword: password,
            success: { (authToken) in
                
                self.userRequest = UserRequest()
                self.userRequest?.getUser(withAuthToken: authToken,
                    success: { (user) in
                        let userSessionFacebook = UserSessionFacebook()
                        userSessionFacebook.initPropertiesFromUser(user: user)
                        userSessionFacebook.authToken = authToken
                        
                        userSessionFacebook.saveSession()
                        success()
                        
                    }, fail: { (error) in
                        failure(error)
                    }
                )
            },
            fail: { (error) in
                failure(error)
            }
        )
    }
    

// MARK: Connexion Methods
    
    func signIn(_ success: @escaping () -> Void, fail failure: @escaping (_ error: Error?) -> Void) {
        let userSession = self.currentSession()
        
        guard let _ = userSession, let _ = userSession?.authToken else {
            failure(DochaRequestError.notAuthenticated)
            self.currentSession()?.deleteSession()
            return
        }
        
        let authToken = userSession!.authToken!
        userRequest = UserRequest()
        
        if userSession!.isKind(of: UserSessionEmail.self) {
            userRequest?.getUser(withAuthToken: authToken,
                success: { (user) in
                    
                    userSession!.initPropertiesFromUser(user: user)
                    userSession!.saveSession()
                    success()
                    
                }, fail: { (error) in
                    self.currentSession()?.deleteSession()
                    failure(error)
                }
            )
            
        } else if userSession!.isKind(of: UserSessionFacebook.self) {
            userRequest?.getUser(withAuthToken: authToken,
                success: { (user) in
                    
                    userSession!.initPropertiesFromUser(user: user)
                    userSession!.saveSession()
                    success()
                    
                }, fail: { (error) in
                    self.currentSession()?.deleteSession()
                    failure(error)
                }
            )
        }
    }
    
    func connectByEmail(_ email: String, andPassword password: String, success: @escaping () -> Void, fail failure: @escaping (_ error: Error?) -> Void) {
        connexionRequest = ConnexionRequest()
            
        connexionRequest?.connexionWithEmail(email, password: password,
            success: { (authToken) in
                
                let authToken = authToken
                self.userRequest = UserRequest()
                self.userRequest?.getUser(withAuthToken: authToken,
                    success: { (user) in
                        
                        let userSessionEmail = UserSessionEmail()
                        userSessionEmail.initPropertiesFromUser(user: user)
                        userSessionEmail.authToken = authToken
                        
                        userSessionEmail.saveSession()
                        success()
                        
                    }, fail: { (error) in
                        failure(error)
                    }
                )
            },
            fail: { (error) in
                failure(error)
            }
        )
    }
    
    func connectByFacebook(withFacebookToken accessToken: String!, success: @escaping () -> Void, fail failure: @escaping (_ error: Error?) -> Void) {
        connexionRequest = ConnexionRequest()
        connexionRequest?.connexionWithFacebook(withFacebookToken: accessToken,
            success: { (authToken) in
                
                let authToken = authToken
                self.userRequest = UserRequest()
                self.userRequest?.getUser(withAuthToken: authToken,
                    success: { (user) in
                        
                        let userSessionFacebook = UserSessionFacebook()
                        userSessionFacebook.initPropertiesFromUser(user: user)
                        userSessionFacebook.authToken = authToken
                        userSessionFacebook.facebookAccessToken = accessToken
                        
                        userSessionFacebook.saveSession()
                        success()
                                            
                    },
                    fail: { (error) in
                        failure(error)
                    }
                )
            },
            fail: { (error) in
                failure(error)
            }
        )
    }
    
    func updateUser(withData data: [String: Any]!, success: @escaping () -> Void, fail failure: @escaping (_ error: Error?) -> Void) {
        guard let authToken = getAuthToken() else {
            failure(DochaRequestError.authTokenNotFound)
            return
        }
        
        userRequest = UserRequest()
        userRequest?.patchUser(withToken: authToken, andData: data,
            success: { (user) in
                
                let currentSession = self.currentSession()
                
                guard let currentSessionUnwrapped = currentSession else {
                    failure(DochaRequestError.userDefaultsNotFound)
                    return
                }
                
                currentSessionUnwrapped.initPropertiesFromUser(user: user)
                currentSessionUnwrapped.saveSession()
                
                success()
                
            }, fail: { (error) in
                failure(error)
            }
        )
    }
    
    func logout() {
        connexionRequest = ConnexionRequest()
        connexionRequest?.logOutUser()
        if let currentSession = currentSession() {
            
            if currentSession.isKind(of: UserSessionFacebook.self) {
                let loginManager = FBSDKLoginManager()
                loginManager.logOut()
            }
            
            currentSession.deleteSession()
            currentSession.deleteProfilImage()
        }
    }
    
    
//MARK: Category Request
    
    func getAllCategory(success: @escaping (_ categoriesList: [Category]) -> Void, fail failure: @escaping (_ error: Error?) -> Void) {
        guard let authToken = getAuthToken() else {
            failure(DochaRequestError.authTokenNotFound)
            return
        }
        
        categoryRequest = CategoryRequest()
        categoryRequest?.getAllCategories(withAuthToken: authToken,
            success: { (categoriesList) in
                
                success(categoriesList)
                
            }, fail: { (error) in
                failure(error)
            }
        )
    }
    
    func get(category slugName: String!, success: @escaping (_ category: Category) -> Void, fail failure: @escaping (_ error: Error?) -> Void) {
        guard let authToken = getAuthToken() else {
            failure(DochaRequestError.authTokenNotFound)
            return
        }
        
        categoryRequest = CategoryRequest()
        categoryRequest?.get(category: slugName, andAuthToken: authToken,
            success: { (category) in
                
                success(category)
                
            }, fail: { (error) in
                failure(error)
            }
        )
    }
}
