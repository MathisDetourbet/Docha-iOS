//
//  UserSessionEmail.swift
//  Docha
//
//  Created by Mathis D on 29/05/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation

class UserSessionEmail: UserSession {
    
    override init() {
        super.init()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
    }
    
    override func getUserProfileImage() -> UIImage? {
        if let avatarString = self.avatarUrl {
            return UIImage(named: avatarString)
            
        } else {
            return UIImage(named: "avatar_man")
        }
    }
}
