//
//  LaunchScreenViewController.swift
//  Docha
//
//  Created by Mathis D on 06/10/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation

class LaunchScreenViewController: UIViewController {
    
    var timer: Timer?
    var timeleft: Double! = 1.0
    var isDisplayingSlyLaunchScreen = true
    
    var timerFinished: Bool! = false {
        didSet {
            if (timerFinished && signInFinished) == true {
                NavSchemeManager.sharedInstance.initRootController()
            }
        }
    }
    
    var signInFinished: Bool! = false {
        didSet {
            if (timerFinished && signInFinished) == true {
                NavSchemeManager.sharedInstance.initRootController()
            }
        }
    }
    
    @IBOutlet weak var slymooverLogoImageView: UIImageView!
    @IBOutlet weak var launchScreenDochaImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTimer()
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    func signInUser() {
        UserSessionManager.sharedInstance.signIn(
            {
                if let token = UserSessionManager.sharedInstance.getDeviceToken() {
                    let notificationsTokens = UserSessionManager.sharedInstance.currentSession()!.notificationTokens
                    if notificationsTokens.contains(token) == false {
                        let data = [UserDataKey.kDeviceToken: token] as [String: Any]
                        UserSessionManager.sharedInstance.setDeviceToken(withData: data,
                            success: { (deviceTokenArray) in
                                print(deviceTokenArray)
                                
                            }, fail: nil)
                    }
                }
                
                self.signInFinished = true
            }
        ) { (error) in
            UserSessionManager.sharedInstance.logout()
            self.signInFinished = true
        }
    }
    
    func initTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.5,
                                     target: self,
                                     selector: #selector(LaunchScreenViewController.updateTimer),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func updateTimer() {
        timeleft = timeleft - 0.5
        
        if timeleft <= 0 {
            if isDisplayingSlyLaunchScreen {
                isDisplayingSlyLaunchScreen = false
                timeleft = 2.0
                displayDochaLaunchScreen()
                
            } else {
                stopTimer()
                timerFinished = true
            }
        }
    }
    
    func displayDochaLaunchScreen() {
        UIView.animate(withDuration: 0.7,
            animations: {
                self.slymooverLogoImageView.alpha = 0.0
            }
        ) { (finished) in
            self.view.layoutIfNeeded()
            self.launchScreenDochaImageView.isHidden = false
            self.signInUser()
        }
    }
}
