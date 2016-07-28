//
//  StorePromotionsViewController.swift
//  Docha
//
//  Created by Mathis D on 08/06/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation
import Amplitude_iOS
import FBSDKShareKit

class StorePromotionsViewController: RootViewController, FBSDKSharingDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Amplitude
        Amplitude.instance().logEvent("StoreViewPromotions")
    }
    
    func sharer(sharer: FBSDKSharing!, didCompleteWithResults results: [NSObject : AnyObject]!) {
        
    }
    
    func sharer(sharer: FBSDKSharing!, didFailWithError error: NSError!) {
        
    }
    
    func sharerDidCancel(sharer: FBSDKSharing!) {
        
    }
    
    @IBAction func inviteFriendsButtonTouched(sender: UIButton) {
        // Facebook Sharing
        let content = FBSDKShareLinkContent()
        content.contentURL = NSURL(string: "http://www.docha.fr")
        let shareDialog = FBSDKShareDialog()
        shareDialog.fromViewController = self
        shareDialog.shareContent = content
        shareDialog.mode = .ShareSheet
        shareDialog.show()
    }
}