//
//  Product.swift
//  TochaProto
//
//  Created by Mathis D on 03/12/2015.
//  Copyright © 2015 LaTV. All rights reserved.
//

import Foundation
import SwiftyJSON

enum Gender: String {
    case male = "male"
    case female = "female"
    case universal = "other"
}

class Product {
    let id: Int
    let model: String
    let brand: String
    let price: Double
    let imageUrl: String
    var image: UIImage?
    let pageUrl: String
    let lastUpdatedDate: Date
    
    init(id: Int, model: String, brand: String, price: Double, imageUrl: String, image: UIImage?, pageUrl: String, lastUpdatedDate: Date) {
        self.id = id
        self.model = model
        self.price = price
        self.imageUrl = imageUrl
        self.image = image
        self.pageUrl = pageUrl
        self.brand = brand
        self.lastUpdatedDate = lastUpdatedDate
    }
    
    convenience init(jsonObject: JSON) {
        let id = jsonObject[ProductDataKey.kId].intValue
        let brand = jsonObject[ProductDataKey.kBrand].stringValue
        let model = jsonObject[ProductDataKey.kModel].stringValue
        let price = Double(jsonObject[ProductDataKey.kPrice].stringValue)
        let pageUrl = jsonObject[ProductDataKey.kPageUrl].stringValue
        let imageUrl = jsonObject[ProductDataKey.kimageUrl].stringValue
        
        let lastUpdatedDateString = jsonObject[ProductDataKey.kLastUpdatedDate].stringValue
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let lastUpdatedDate = dateFormatter.date(from: lastUpdatedDateString)
        
        self.init(id: id, model: model, brand: brand, price: price!, imageUrl: imageUrl, image: nil, pageUrl: pageUrl, lastUpdatedDate: lastUpdatedDate ?? Date())
    }
}
