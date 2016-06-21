//
//  ProductManager.swift
//  DochaProto
//
//  Created by Mathis D on 01/05/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import SwiftyJSON

extension UIImageView {
    func downloadedFrom(link link:String, contentMode mode: UIViewContentMode) {
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
            }
        }).resume()
    }
}

class ProductManager {
    var products: [Product]?
    var productsImagesViews: [UIImageView]?
    
    class var sharedInstance: ProductManager {
        struct Singleton {
            static let instance = ProductManager()
        }
        return Singleton.instance
    }
    
    func loadProductsWithCurrentCategory() {
        let category = UserSessionManager.sharedInstance.currentSession()?.categoryFavorite
        let jsonName = "decoration"
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
        if self.products != nil {
            let productsShuffled = self.products!.shuffle()
            var packOfProducts: [Product]? = []
            
            for index in 0...4 {
                packOfProducts!.append(productsShuffled[index])
            }
            
            return packOfProducts
            
        } else {
            print("products of productManager is nil... Need to call loadPacksOfProductsWithCurrentCategory before")
            return nil
        }
    }
    
    func downloadProductsImages() {
        self.productsImagesViews = []
        
        for product in self.products! {
            let imageURL = product.imageURL
            let imageView = UIImageView()
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                imageView.downloadedFrom(link: imageURL, contentMode: UIViewContentMode.ScaleAspectFit)
                self.productsImagesViews!.append(imageView)
            }
        }
    }
}