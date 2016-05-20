//
//  Coupon.swift
//  DochaProto
//
//  Created by Mathis D on 29/01/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

class Coupon: NSObject {
    let name: String?
    let brandName: String?
    let brandImage: UIImage?
    let categories: String?
    let price: Int?
    let percentage: Int?
    
    init(name: String, brandName: String, brandImage: UIImage, categories: String, price: Int, percentage: Int) {
        self.name = name
        self.brandName = brandName
        self.brandImage = brandImage
        self.categories = categories
        self.price = price
        self.percentage = percentage
    }
}
