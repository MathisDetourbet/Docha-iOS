//
//  ProductManager.swift
//  DochaProto
//
//  Created by Mathis D on 01/05/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import SwiftyJSON

extension UIImageView {
    func downloadedFrom(link link:String, contentMode mode: UIViewContentMode, WithCompletion completion: (() -> Void)?) {
        guard
            let url = NSURL(string: link)
            else {return}
        contentMode = mode
        NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            guard
                let httpURLResponse = response as? NSHTTPURLResponse where httpURLResponse.statusCode == 200,
                let mimeType = response?.MIMEType where mimeType.hasPrefix("image"),
                let data = data where error == nil,
                let image = UIImage(data: data)
                else { return }
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.image = image
                completion?()
            }
        }).resume()
    }
}


class ProductManager {
    let PACK_PRODUCT_COUNT = 5
    
    var products: [Product]?
    var currentPackOfProducts: [Product]?
    var productsImages: [String:UIImage]?
    
    class var sharedInstance: ProductManager {
        struct Singleton {
            static let instance = ProductManager()
        }
        return Singleton.instance
    }
    
    func loadProductsWithCurrentCategory() {
        let jsonName = "products_beta"
        guard
            let jsonPath = NSBundle.mainBundle().pathForResource(jsonName, ofType: "json"),
            let jsonData = NSData.init(contentsOfFile: jsonPath),
            let json = JSON(data: jsonData) as JSON?,
            let jsonArray = json["products"].array
            else { return }
        
        var id = 0
        self.products = []
        
        for jsonDico in jsonArray {
            let pageURL = jsonDico["page_url"].stringValue
            let category = "Lifestyle"
            let model = jsonDico["name"].stringValue
            let brand = jsonDico["brand"].stringValue
            let price = jsonDico["price"].doubleValue
            let imageURL = jsonDico["image_url"].stringValue
            let categoriesString = jsonDico["description"].stringValue
            
            let genderString = jsonDico["gender"].stringValue
            let gender: Gender
            switch genderString {
            case "M":
                gender = Gender.Male
                break
            case "F":
                gender = Gender.Female
                break
            default:
                gender = Gender.Universal
                break
            }
            let caracteristiques: [String] = categoriesString.characters.split{$0 == "#"}.map(String.init)
            
            let product = Product(id: id, category: category, model: model, brand: brand, price: price, imageURL: imageURL, caracteristiques: caracteristiques, image: nil, pageURL: pageURL, gender: gender)
            
            self.products!.append(product)
            id += 1
        }
        print("\(jsonName).json loaded with \(products!.count) products")
    }
    
    func loadPackOfProducts() -> [Product]? {
        if self.products == nil {
            print("products of productManager is nil... Need to call loadPacksOfProductsWithCurrentCategory() before")
            return nil
        }
        
        var packOfProducts: [Product]? = []
        var userGender: Gender = Gender.Universal
        
        if let gender = UserSessionManager.sharedInstance.currentSession()?.gender {
            switch gender {
            case "M":
                userGender = Gender.Male
                break
            case "F":
                userGender = Gender.Female
                break
            default:
                userGender = Gender.Universal
                break
            }
        }
        
        let productsCountMax = getProductsCountForGender(userGender)
        let productsID = UserSessionManager.sharedInstance.currentSession()!.productsIDPlayed
        
        if var productsIDPlayed = productsID {
            var index = 0
            var productsShuffled = self.products!.shuffle()
            
            if productsIDPlayed.count == productsCountMax {
                productsIDPlayed.removeAll()
                let userSession = UserSessionManager.sharedInstance.currentSession()
                userSession?.productsIDPlayed = productsIDPlayed
                userSession?.saveSession()
            }
            
            while (packOfProducts?.count < PACK_PRODUCT_COUNT) || (index == self.products?.count) {
                let product = productsShuffled[index]
                if (!(productsIDPlayed.contains(product.id)) && ((product.gender == userGender) || (product.gender == .Universal))) {
                    packOfProducts?.append(product)
                    productsIDPlayed.append(product.id)
                }
                index += 1
            }
            
            if packOfProducts?.count == PACK_PRODUCT_COUNT {
                self.currentPackOfProducts = packOfProducts
                return self.currentPackOfProducts
                
            } else {
                productsIDPlayed.removeAll()
                for product in packOfProducts! {
                    productsIDPlayed.append(product.id)
                }
                productsShuffled = self.products!.shuffle()
                index = 0
                
                while (packOfProducts?.count < PACK_PRODUCT_COUNT) || (index == self.products?.count) {
                    let product = productsShuffled[index]
                    if (!(productsIDPlayed.contains(product.id)) && ((product.gender == userGender) || (product.gender == .Universal))) {
                        packOfProducts?.append(product)
                        productsIDPlayed.append(product.id)
                    }
                    index += 1
                }
                
                if packOfProducts?.count == PACK_PRODUCT_COUNT {
                    self.currentPackOfProducts = packOfProducts
                    return self.currentPackOfProducts
                }
            }
            
        } else {
            var index = 0
            var productsShuffled = self.products!.shuffle()
            var productsIDPlayed = [Int]()
            
            while (packOfProducts?.count < PACK_PRODUCT_COUNT) || (index == self.products?.count) {
                let product = productsShuffled[index]
                if (!(productsIDPlayed.contains(product.id)) && ((product.gender == userGender) || (product.gender == .Universal))) {
                    packOfProducts?.append(product)
                    productsIDPlayed.append(product.id)
                }
                index += 1
            }
        }
        
        if packOfProducts?.count == PACK_PRODUCT_COUNT {
            self.currentPackOfProducts = packOfProducts
            return self.currentPackOfProducts
            
        } else {
            return nil
        }
    }
    
    func getProductsCountForGender(gender: Gender) -> Int {
        if self.products == nil {
            return 0
        }
        
        if gender == .Universal {
            return (self.products?.count)!
        }
        
        var cptProducts = 0
        
        for product in self.products! {
            if (product.gender == gender) || (product.gender == .Universal) {
                cptProducts += 1
            }
        }
        
        return cptProducts
    }
    
    func saveProductsIDPlayed() {
        let currentPackOfProducts = self.currentPackOfProducts
        let userSession = UserSessionManager.sharedInstance.currentSession()
        var productsIDPlayed = userSession!.productsIDPlayed
        
        if productsIDPlayed == nil {
            productsIDPlayed = [Int]()
        }
        
        if let currentPackOfProducts = currentPackOfProducts {
            for product in currentPackOfProducts {
                productsIDPlayed?.append(product.id)
            }
        }
        userSession?.productsIDPlayed = productsIDPlayed
        userSession?.saveSession()
    }
    
    func downloadProductsImages(packOfProducts: [Product]!, WithCompletion completion: (finished: Bool) -> Void) {
        self.productsImages = [String:UIImage]()
        
        for product in packOfProducts! {
            let imageURL = product.imageURL
            let imageView = UIImageView()
            
            dispatch_async(dispatch_get_main_queue(), {
                imageView.downloadedFrom(link: imageURL, contentMode: .ScaleAspectFit, WithCompletion: {
                    self.productsImages!["\(product.id)"] = imageView.image!
                    
                    if self.productsImages?.count == packOfProducts.count {
                        completion(finished: true)
                    }
                })
                
            })
        }
    }
}