//
//  Category.swift
//  Docha
//
//  Created by Mathis D on 03/10/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation
import SwiftyJSON

class Category: NSObject, NSCoding {
    
    var name: String
    var slugName: String
    var image: UIImage?
    
    init(name: String, slugName: String, image: UIImage? = nil) {
        self.name = name
        self.slugName = slugName
        self.image = image
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: Constants.UserDefaultsKey.kUserInfosCategoryName) as? String ?? ""
        let slugName = aDecoder.decodeObject(forKey: Constants.UserDefaultsKey.kUserInfosCategorySlugName) as? String ?? ""
        
        self.init(name: name, slugName: slugName)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: Constants.UserDefaultsKey.kUserInfosCategoryName)
        aCoder.encode(self.slugName, forKey: Constants.UserDefaultsKey.kUserInfosCategorySlugName)
    }
}
