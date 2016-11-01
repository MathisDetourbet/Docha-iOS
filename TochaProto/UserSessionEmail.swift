//
//  UserSessionEmail.swift
//  Docha
//
//  Created by Mathis D on 29/05/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation

enum AvatarDochaSize: String {
    case small = "small"
    case medium = "medium"
    case large = "large"
}

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
    
    func getUserAvatarImage(withSize size: AvatarDochaSize) -> UIImage? {
        if let avatarUrl = avatarUrl {
            return UIImage(named: "\(avatarUrl)_\(size))")
            
        } else {
            if let gender = self.gender {
                if gender == .female {
                    return UIImage(named: "avatar_woman_\(size)")
                }
            }
            
            return UIImage(named: "avatar_man_\(size)")
        }
    }
}
