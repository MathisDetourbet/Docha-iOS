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
    
    func sharer(_ sharer: FBSDKSharing!, didCompleteWithResults results: [AnyHashable: Any]!) {
        
    }
    
    func sharer(_ sharer: FBSDKSharing!, didFailWithError error: NSError!) {
        
    }
    
    func sharerDidCancel(_ sharer: FBSDKSharing!) {
        
    }
    
    @IBAction func inviteFriendsButtonTouched(_ sender: UIButton) {
        // Facebook Sharing
        let content = FBSDKShareLinkContent()
        content.contentURL = URL(string: "http://www.docha.fr")
        let shareDialog = FBSDKShareDialog()
        shareDialog.fromViewController = self
        shareDialog.shareContent = content
        shareDialog.mode = .shareSheet
        shareDialog.show()
    }
}
