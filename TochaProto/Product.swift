//
//  Product.swift
//  TochaProto
//
//  Created by Mathis D on 03/12/2015.
//  Copyright © 2015 LaTV. All rights reserved.
//

import Foundation

enum Gender {
    case Male
    case Female
    case Universal
}

class Product: NSObject {
    let id: Int
    let model: String
    let brand: String
    let price: Double
    let category: String
    let imageURL: String
    var image: UIImage?
    let caracteristiques: [String]
    let pageURL: String
    let gender: Gender
    
    init(id: Int, category: String, model: String, brand: String, price: Double, imageURL: String, caracteristiques: [String], image: UIImage?, pageURL: String, gender: Gender) {
        self.id = id
        self.category = category
        self.model = model
        self.price = price
        self.imageURL = imageURL
        self.caracteristiques = caracteristiques
        self.image = image
        self.pageURL = pageURL
        self.brand = brand
        self.gender = gender
    }
}