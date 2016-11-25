//
//  UserSessionManager.swift
//  DochaProto
//
//  Created by Mathis D on 20/05/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Alamofire
import Kingfisher
import Crashlytics

class UserSessionManager {
	
    var connexionRequest: ConnexionRequest?
    var registrationRequest: RegistrationRequest?
    var userRequest: UserRequest?
    var categoryRequest: CategoryRequest?
    
    class var sharedInstance: UserSessionManager {
        struct Singleton {
            static let instance = UserSessionManager()
        }
        return Singleton.instance
    }
    
    
//MARK: - User Data Methods
	
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
    
    func hasFinishedTutorial() -> Bool {
        let userDefaults = UserDefaults.standard
        let tutorialFinished = userDefaults.bool(forKey: Constants.UserDefaultsKey.kUserHasFinishedTutorial)
        return tutorialFinished
    }
    
    func didFinishedTutorial(finished: Bool = true) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(finished, forKey: Constants.UserDefaultsKey.kUserHasFinishedTutorial)
        userDefaults.synchronize()
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
    
    func downloadAndSaveAvatarImage(withAvatarUrl avatarUrl: String!) {
        if let url = URL(string: avatarUrl) {
            ImageDownloader.default.downloadImage(with: url, options: [], progressBlock: nil) {
                (image, error, url, data) in
                if let image = image {
                    self.currentSession()?.saveUserAvatarImage(image)
                }
            }
        }
    }
    
    func getUserInfosAndAvatarImage(withImageSize imageSize: AvatarDochaSize = .medium) -> (user: User?, avatarImage: UIImage?) {
        if let currentSession = currentSession() {
            let user = User()
            user.initPropertiesFromUser(currentSession)
            
            if currentSession.isKind(of: UserSessionEmail.self) {
                let userSessionEmail = currentSession as! UserSessionEmail
                let avatarImage = userSessionEmail.getUserAvatarImage(withSize: imageSize)
                return (user, avatarImage)
                
            } else if currentSession.isKind(of: UserSessionFacebook.self) {
                let userSessionFacebook = currentSession as! UserSessionFacebook
                let avatarImage = userSessionFacebook.getUserAvatarImage()
                
                return (user, avatarImage)
            }
        }
        
        return (nil, nil)
    }
    
    func isFacebookUser() -> Bool {
        if let currentSession = currentSession() {
            if currentSession.isKind(of: UserSessionFacebook.self) {
                return true
                
            } else {
                return false
            }
        }
        
        return false
    }
    
    
//MARK: - Device Token Methods (Notifications)
    
    func uptdateDeviceTokenIfNeeded(withCompletion completion: (() -> Void)?) {
        if let token = getDeviceToken() {
            let notificationsTokens = currentSession()!.notificationTokens
            if notificationsTokens.contains(token) == false {
                let data = [UserDataKey.kDeviceToken: token] as [String: Any]
                
                setDeviceToken(withData: data,
                    success: { (deviceTokenArray) in
                        
                        print(deviceTokenArray)
                        completion?()
                        
                                                                    
                    }, fail: { (error) in
                        completion?()
                    }
                )
            } else {
                completion?()
            }
        } else {
            completion?()
        }
    }
    
    func save(deviceToken token : String!) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(token, forKey: Constants.UserDefaultsKey.kDeviceToken)
        userDefaults.synchronize()
    }
    
    func getDeviceToken() -> String? {
        let userDefaults = UserDefaults.standard
        let token = userDefaults.object(forKey: Constants.UserDefaultsKey.kDeviceToken) as? String
        
        return token ?? nil
    }
    
    func setDeviceToken(withData data: [String: Any]!, success: @escaping (_ deviceTokensList: [String]) -> Void, fail failure: ((_ error: Error?) -> Void)?) {
        
        guard let authToken = getAuthToken() else {
            failure?(DochaRequestError.authTokenNotFound)
            return
        }
        
        userRequest = UserRequest()
        userRequest?.postDeviceToken(withAuthToken: authToken, andData: data,
            success: { (user) in
                success(user.notificationTokens)
                                        
            }, fail: { (error) in
                failure?(error)
            }
        )
    }
    
    
//MARK: - User Inscription Request
    
    // Email inscription
    func registrationByEmail(_ email: String!, andPassword password: String!, success: @escaping () -> Void, fail failure: @escaping (_ error: Error?) -> Void) {
        
        registrationRequest = RegistrationRequest()
        registrationRequest?.registrationByEmail(withEmail: email, andPassword: password,
            success: { (authToken) in
                
                self.userRequest = UserRequest()
                self.userRequest?.getUser(withAuthToken: authToken,
                    success: { (user) in
                        
                        Answers.logSignUp(withMethod: "sign_up_by_email", success: true, customAttributes: nil)
                        
                        let userSessionEmail = UserSessionEmail()
                        userSessionEmail.initPropertiesFromUser(user)
                        userSessionEmail.authToken = authToken
                        
                        userSessionEmail.saveSession()
                        success()
                        
                    }, fail: { (error) in
                        
                        Answers.logSignUp(withMethod: "signup_by_email", success: false, customAttributes: nil)
                        failure(error)
                    }
                )
            },
            fail: { (error) in
                failure(error)
            }
        )
    }
    

// MARK: - User Connection Requests
    
    func signIn(_ success: @escaping () -> Void, fail failure: @escaping (_ error: Error?) -> Void) {
        
        getUser(
            success: {
                
                Answers.logLogin(withMethod: "sign_in", success: true, customAttributes: nil)
                success()
            }
            
        ) { (error) in
            
            Answers.logLogin(withMethod: "sign_in", success: false, customAttributes: nil)
            failure(error)
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
                        
                        Answers.logLogin(withMethod: "sign_in_by_email", success: true, customAttributes: nil)
                        
                        let userSessionEmail = UserSessionEmail()
                        userSessionEmail.initPropertiesFromUser(user)
                        userSessionEmail.authToken = authToken
                        
                        userSessionEmail.saveSession()
                        success()
                        
                    }, fail: { (error) in
                        
                        Answers.logLogin(withMethod: "sign_in_by_email", success: false, customAttributes: nil)
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
                        
                        Answers.logLogin(withMethod: "sign_in_by_facebook", success: true, customAttributes: nil)
                        
                        let userSessionFacebook = UserSessionFacebook()
                        userSessionFacebook.initPropertiesFromUser(user)
                        userSessionFacebook.authToken = authToken
                        userSessionFacebook.facebookAccessToken = accessToken
                        
                        if let avatarUrl = userSessionFacebook.avatarUrl {
                            self.downloadAndSaveAvatarImage(withAvatarUrl: avatarUrl)
                        }
                        
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
    
    func logout() {
        connexionRequest = ConnexionRequest()
        connexionRequest?.logOutUser()
        if let currentSession = currentSession() {
            
            if currentSession.isKind(of: UserSessionFacebook.self) {
                let loginManager = FBSDKLoginManager()
                loginManager.logOut()
            }
            
            currentSession.deleteSession()
            currentSession.deleteUserAvatarImage()
        }
    }
    
    
//MARK: - User Update Requests
    
    func getUser(success: @escaping () -> Void, fail failure: @escaping (_ error: Error?) -> Void) {
        guard let authToken = getAuthToken() else {
            failure(DochaRequestError.authTokenNotFound)
            return
        }
        
        userRequest = UserRequest()
        
        let userSession = self.currentSession()
        if userSession!.isKind(of: UserSessionEmail.self) {
            userRequest?.getUser(withAuthToken: authToken,
                success: { (user) in
                    
                    userSession!.initPropertiesFromUser(user)
                    userSession!.saveSession()
                    success()
                    
                }, fail: { (error) in
                    failure(error)
                }
            )
            
        } else if userSession!.isKind(of: UserSessionFacebook.self) {
            userRequest?.getUser(withAuthToken: authToken,
                success: { (user) in
                    
                    userSession!.initPropertiesFromUser(user)
                    userSession!.saveSession()
                    success()
                    
                }, fail: { (error) in
                    failure(error)
                }
            )
        }
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
                
                currentSessionUnwrapped.initPropertiesFromUser(user)
                currentSessionUnwrapped.saveSession()
                
                success()
                
            }, fail: { (error) in
                failure(error)
            }
        )
    }
    
    func changeUserPassword(withData data: [String: Any]!, success: @escaping () -> Void, fail failure: @escaping (_ error: Error?) -> Void) {
        guard let authToken = getAuthToken() else {
            failure(DochaRequestError.authTokenNotFound)
            return
        }
        
        userRequest = UserRequest()
        userRequest?.postChangePassword(withAuthToken: authToken, andData: data,
            success: {
                success()
                
            }, fail: { (error) in
                failure(error)
            }
        )
    }
    
    
//MARK: - Category Requests
    
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
    
    func getCategory(withSlugName slugName: String!, success: @escaping (_ category: Category) -> Void, fail failure: @escaping (_ error: Error?) -> Void) {
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
    
    func renewCategories(forMatchID matchID: Int!, andRoundID roundID: Int!, success: @escaping (_ categories: [Category]) -> Void, fail failure: @escaping (_ error: Error?) -> Void) {
        guard let authToken = getAuthToken() else {
            failure(DochaRequestError.authTokenNotFound)
            return
        }
        
        categoryRequest = CategoryRequest()
        categoryRequest?.postRenewCategories(withAuthtoken: authToken, forMatchID: matchID, andRoundID: roundID,
            success: { (categories) in
                self.getUser(
                    success: {
                        success(categories)
                        
                    }, fail: { (error) in
                        failure(error)
                    }
                )
                
            }, fail: { (error) in
                failure(error)
            }
        )
    }
}
