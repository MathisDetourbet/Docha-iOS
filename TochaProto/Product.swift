//
//  Product.swift
//  TochaProto
//
//  Created by Mathis D on 03/12/2015.
//  Copyright © 2015 LaTV. All rights reserved.
//

import Foundation

class Product: NSObject {
    let id: Int
    let category: String
    let model: String
    let price: Double
    let imageURL: String
    var image: UIImage?
    let caracteristiques: [String]
    
//    init(id: Int, name: String, price: Double, imageName: String, brand: String, distributeur: String) {
//        self.id = id
//        self.name = name
//        self.price = price
//        self.imageName = imageName
//        self.brand = brand
//        self.distributeur = distributeur
//    }
    
    init(id: Int, category: String, model: String, price: Double, imageURL: String, caracteristiques: [String]) {
        self.id = id
        self.category = category
        self.model = model
        self.price = price
        self.imageURL = imageURL
        self.caracteristiques = caracteristiques
        self.image = nil
    }
}