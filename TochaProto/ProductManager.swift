//
//  ProductManager.swift
//  DochaProto
//
//  Created by Mathis D on 01/05/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import SwiftyJSON
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


extension UIImageView {
    func downloadedFrom(link:String, contentMode mode: UIViewContentMode, WithCompletion completion: @escaping ((_ success: Bool) -> Void)) {
        guard
            let url = URL(string: link)
            else {return}
        contentMode = mode
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
            guard
                let httpURLResponse = response as? HTTPURLResponse , httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType , mimeType.hasPrefix("image"),
                let data = data , error == nil,
                let image = UIImage(data: data)
                else {
                    completion(false)
                    return
                }
            DispatchQueue.main.async { () -> Void in
                self.image = image
                completion(true)
            }
        }).resume()
    }
    
    func downloadedImageWithHightPriority(link:String, contentMode mode: UIViewContentMode, WithCompletion completion: @escaping ((_ success: Bool) -> Void)) {
        guard
            let url = URL(string: link)
            else {return}
        contentMode = mode
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
            guard
                let httpURLResponse = response as? HTTPURLResponse , httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType , mimeType.hasPrefix("image"),
                let data = data , error == nil,
                let image = UIImage(data: data)
                else {
                    completion(false)
                    return
            }
            DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.high).async(execute: {
                self.image = image
                completion(true)
            })
        }).resume()
    }
}


class ProductManager {
    let PACK_PRODUCT_COUNT = 3
    
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
            let jsonPath = Bundle.main.path(forResource: jsonName, ofType: "json"),
            let jsonData = try? Data.init(contentsOf: URL(fileURLWithPath: jsonPath)),
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
                gender = Gender.male
                break
            case "F":
                gender = Gender.female
                break
            default:
                gender = Gender.universal
                break
            }
            let caracteristiques: [String] = categoriesString.characters.split{$0 == "#"}.map(String.init)
            
            let product = Product(id: id, category: category, model: model, brand: brand, price: price, imageURL: imageURL, caracteristiques: caracteristiques, image: nil, pageURL: pageURL, gender: gender)
            
            self.products!.append(product)
        }
        print("\(jsonName).json loaded with \(products!.count) products")
    }
    
    func loadPackOfProducts(_ numberOfProducts: Int?) -> [Product]? {
        if self.products == nil {
            print("products of productManager is nil... Need to call loadPacksOfProductsWithCurrentCategory() before : this method has just being called. Try again")
            loadProductsWithCurrentCategory()
            return nil
        }
        
        var packOfProducts: [Product]? = []
        var userGender: Gender = Gender.universal
        
        if let gender = UserSessionManager.sharedInstance.currentSession()?.gender {
            switch gender {
            case "M":
                userGender = Gender.male
                break
            case "F":
                userGender = Gender.female
                break
            default:
                userGender = Gender.universal
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
                    ((product.gender == userGender) || (product.gender == .universal)) &&
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
                        ((product.gender == userGender) || (product.gender == .universal)) &&
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
                    ((product.gender == userGender) || (product.gender == .universal)) &&
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
    
    func getProductsCountForGender(_ gender: Gender) -> Int {
        if self.products == nil {
            return 0
        }
        
        if gender == .universal {
            return (self.products?.count)!
        }
        
        var cptProducts = 0
        
        for product in self.products! {
            if (product.gender == gender) || (product.gender == .universal) {
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
    
    func getPackOfProducts(_ completion: @escaping (_ finished: Bool, _ packOfProducts: [Product]?) -> Void) {
        var numberProductMissing: Int?
        self.currentPackOfProducts = []
        self.currentPackOfProductsNoImage = []
        var finalPackOfProducts: [Product] = []
        var isDonwloadFinished = true
        
        while numberProductMissing != 0 {
            if isDonwloadFinished {
                
                isDonwloadFinished = false
                
                DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: {
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
                                    completion(true, self.currentPackOfProducts)
                                }
                                
                            } else {
                                let userSession = UserSessionManager.sharedInstance.currentSession()
                                var errorProductID = userSession?.productsIDPlayed ?? []
                                
                                for errorProduct in errorProductsArray {
                                    let indexProductInPack = packOfProducts?.index(of: errorProduct)
                                    if let indexProductInPack = indexProductInPack {
                                        packOfProducts?.remove(at: indexProductInPack)
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
                        completion(false, nil)
                    }
                })
            }
            Thread.sleep(forTimeInterval: 1.0)
        }
    }
    
    func downloadProductsImages(_ packOfProducts: [Product]!, WithCompletion completion: @escaping (_ successImages: [String:UIImage], _ errorProductsArray: [Product]) -> Void) {
        self.productsImages = [String : UIImage]()
        var successImages: [String: UIImage] = [String : UIImage]()
        var errorProductsArray: [Product] = []
        
        for product in packOfProducts! {
            let imageURL = product.imageURL
            let imageView = UIImageView()
            
            DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.high).async(execute: {
                imageView.downloadedImageWithHightPriority(link: imageURL, contentMode: .scaleAspectFit, WithCompletion: {(success) in
                    if success {
                        successImages["\(product.id)"] = imageView.image!
                        
                        if (successImages.count + errorProductsArray.count) == packOfProducts.count {
                            completion(successImages, errorProductsArray)
                        }
                        
                    } else {
                        errorProductsArray.append(product)
                        
                        if (successImages.count + errorProductsArray.count) == packOfProducts.count {
                            completion(successImages, errorProductsArray)
                        }
                    }
                })
                
            })
        }
    }
}
