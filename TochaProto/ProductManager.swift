//
//  ProductManager.swift
//  DochaProto
//
//  Created by Mathis D on 01/05/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import SwiftyJSON

extension UIImageView {
    func downloadedFrom(link link:String, contentMode mode: UIViewContentMode, WithCompletion completion: ((success: Bool) -> Void)) {
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
                else {
                    completion(success: false)
                    return
                }
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.image = image
                completion(success: true)
            }
        }).resume()
    }
    
    func downloadedImageWithHightPriority(link link:String, contentMode mode: UIViewContentMode, WithCompletion completion: ((success: Bool) -> Void)) {
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
                else {
                    completion(success: false)
                    return
            }
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
                self.image = image
                completion(success: true)
            })
        }).resume()
    }
}


class ProductManager {
    let PACK_PRODUCT_COUNT = 5
    
    var products: [Product]?
    var currentPackOfProducts: [Product]?
    var currentPackOfProductsNoImage: [Product]?
    var productsImages: [String:UIImage]?
    
    class var sharedInstance: ProductManager {
        struct Singleton {
            static let instance = ProductManager()
        }
        return Singleton.instance
    }
    
    func loadProductsWithCurrentCategory() {
        let jsonName = "products_beta_v0.2"
        guard
            let jsonPath = NSBundle.mainBundle().pathForResource(jsonName, ofType: "json"),
            let jsonData = NSData.init(contentsOfFile: jsonPath),
            let json = JSON(data: jsonData) as JSON?,
            let jsonArray = json["products"].array
            else { return }
        
        self.products = []
        
        for jsonDico in jsonArray {
            let id = jsonDico["id"].intValue
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
        }
        print("\(jsonName).json loaded with \(products!.count) products")
    }
    
    func loadPackOfProducts(numberOfProducts: Int?) -> [Product]? {
        if self.products == nil {
            print("products of productManager is nil... Need to call loadPacksOfProductsWithCurrentCategory() before : this method has just being called. Try again")
            loadProductsWithCurrentCategory()
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
        let productsID = UserSessionManager.sharedInstance.currentSession()?.productsIDPlayed
        
        if var productsIDPlayed = productsID {
            var index = 0
            var productsShuffled = self.products!.shuffle()
            
            if productsIDPlayed.count == productsCountMax {
                productsIDPlayed.removeAll()
                let userSession = UserSessionManager.sharedInstance.currentSession()
                userSession?.productsIDPlayed = productsIDPlayed
                userSession?.saveSession()
            }
            
            while (packOfProducts?.count < numberOfProducts ?? PACK_PRODUCT_COUNT) || (index == self.products?.count) {
                let product = productsShuffled[index]
                
                if (!(productsIDPlayed.contains(product.id)) &&
                    ((product.gender == userGender) || (product.gender == .Universal)) &&
                    (self.currentPackOfProducts?.contains(product) == false)) {
                    
                    packOfProducts?.append(product)
                    productsIDPlayed.append(product.id)
                }
                index += 1
            }
            
            if packOfProducts?.count == numberOfProducts ?? PACK_PRODUCT_COUNT {
                self.currentPackOfProductsNoImage = packOfProducts
                return self.currentPackOfProductsNoImage
                
            } else {
                productsIDPlayed.removeAll()
                for product in packOfProducts! {
                    productsIDPlayed.append(product.id)
                }
                productsShuffled = self.products!.shuffle()
                index = 0
                
                while (packOfProducts?.count < numberOfProducts ?? PACK_PRODUCT_COUNT) || (index == self.products?.count) {
                    let product = productsShuffled[index]
                    
                    if (!(productsIDPlayed.contains(product.id)) &&
                        ((product.gender == userGender) || (product.gender == .Universal)) &&
                        (self.currentPackOfProducts?.contains(product) == false)) {
                        
                        packOfProducts?.append(product)
                        productsIDPlayed.append(product.id)
                    }
                    index += 1
                }
                
                if packOfProducts?.count == numberOfProducts ?? PACK_PRODUCT_COUNT {
                    self.currentPackOfProductsNoImage = packOfProducts
                    return self.currentPackOfProductsNoImage
                }
            }
            
        } else {
            var index = 0
            var productsShuffled = self.products!.shuffle()
            var productsIDPlayed = [Int]()
            
            while (packOfProducts?.count < numberOfProducts ?? PACK_PRODUCT_COUNT) || (index == self.products?.count) {
                let product = productsShuffled[index]
                
                if (!(productsIDPlayed.contains(product.id)) &&
                    ((product.gender == userGender) || (product.gender == .Universal)) &&
                    (self.currentPackOfProducts?.contains(product) == false)) {
                    
                    packOfProducts?.append(product)
                    productsIDPlayed.append(product.id)
                }
                index += 1
            }
        }
        
        if packOfProducts?.count == numberOfProducts ?? PACK_PRODUCT_COUNT {
            self.currentPackOfProductsNoImage = packOfProducts
            return self.currentPackOfProductsNoImage
            
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
            productsIDPlayed = []
        }
        
        if let currentPackOfProducts = currentPackOfProducts {
            for product in currentPackOfProducts {
                productsIDPlayed?.append(product.id)
            }
        }
        userSession?.productsIDPlayed = productsIDPlayed
        userSession?.saveSession()
    }
    
    func getPackOfProducts(completion: (finished: Bool, packOfProducts: [Product]?) -> Void) {
        var numberProductMissing: Int?
        self.currentPackOfProducts = []
        self.currentPackOfProductsNoImage = []
        var finalPackOfProducts: [Product] = []
        var isDonwloadFinished = true
        
        while numberProductMissing != 0 {
            if isDonwloadFinished {
                
                isDonwloadFinished = false
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    var packOfProducts = self.loadPackOfProducts(numberProductMissing)
                    
                    if (packOfProducts != nil) && (packOfProducts?.isEmpty == false) {
                        self.downloadProductsImages(packOfProducts) { (successImages, errorProductsArray) in
                            
                            if errorProductsArray.isEmpty {
                                for index in 0...successImages.count-1 {
                                    packOfProducts![index].image = successImages["\(packOfProducts![index].id)"]
                                }
                                
                                finalPackOfProducts += packOfProducts!
                                
                                if finalPackOfProducts.count == self.PACK_PRODUCT_COUNT {
                                    self.currentPackOfProducts = finalPackOfProducts
                                    numberProductMissing = 0
                                    isDonwloadFinished = true
                                    completion(finished: true, packOfProducts: self.currentPackOfProducts)
                                }
                                
                            } else {
                                let userSession = UserSessionManager.sharedInstance.currentSession()
                                var errorProductID = userSession?.productsIDPlayed ?? []
                                
                                for errorProduct in errorProductsArray {
                                    let indexProductInPack = packOfProducts?.indexOf(errorProduct)
                                    if let indexProductInPack = indexProductInPack {
                                        packOfProducts?.removeAtIndex(indexProductInPack)
                                    }
                                    
                                    errorProductID.append(errorProduct.id)
                                }
                                
                                userSession?.productsIDPlayed = errorProductID
                                userSession?.saveSession()
                                
                                if successImages.isEmpty == false {
                                    for index in 0...successImages.count-1 {
                                        packOfProducts![index].image = successImages["\(packOfProducts![index].id)"]
                                    }
                                }
                                
                                finalPackOfProducts += packOfProducts!
                                
                                numberProductMissing = self.PACK_PRODUCT_COUNT - (packOfProducts?.count)!
                                isDonwloadFinished = true
                            }
                        }
                        
                    } else {
                        completion(finished: false, packOfProducts: nil)
                    }
                })
            }
            NSThread.sleepForTimeInterval(1.0)
        }
    }
    
    func downloadProductsImages(packOfProducts: [Product]!, WithCompletion completion: (successImages: [String:UIImage], errorProductsArray: [Product]) -> Void) {
        self.productsImages = [String : UIImage]()
        var successImages: [String: UIImage] = [String : UIImage]()
        var errorProductsArray: [Product] = []
        
        for product in packOfProducts! {
            let imageURL = product.imageURL
            let imageView = UIImageView()
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
                imageView.downloadedImageWithHightPriority(link: imageURL, contentMode: .ScaleAspectFit, WithCompletion: {(success) in
                    if success {
                        successImages["\(product.id)"] = imageView.image!
                        
                        if (successImages.count + errorProductsArray.count) == packOfProducts.count {
                            completion(successImages: successImages, errorProductsArray: errorProductsArray)
                        }
                        
                    } else {
                        errorProductsArray.append(product)
                        
                        if (successImages.count + errorProductsArray.count) == packOfProducts.count {
                            completion(successImages: successImages, errorProductsArray: errorProductsArray)
                        }
                    }
                })
                
            })
        }
    }
}