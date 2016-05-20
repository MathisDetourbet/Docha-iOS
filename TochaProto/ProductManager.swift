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
    var products: [Product] = []
    var productsImagesViews: [UIImageView] = []
    
    class var sharedInstance: ProductManager {
        struct Singleton {
            static let instance = ProductManager()
        }
        return Singleton.instance
    }
    
    func loadPacksOfProducts() {
        guard
            let jsonPath = NSBundle.mainBundle().pathForResource("products_category", ofType: "json"),
            let jsonData = NSData.init(contentsOfFile: jsonPath),
            let json = Optional(JSON(data: jsonData)),
            let jsonArray = json["products"].array
            else { return }
        
        for jsonDico in jsonArray {
            let id = jsonDico["id"].intValue
            let category = jsonDico["category"].stringValue
            let model = jsonDico["name"].stringValue
            let price = jsonDico["price"].doubleValue
            let imageURL = jsonDico["image_url"].stringValue
            var caracteristiques: [String] = []
            for caract in jsonDico["descriptionList"].arrayValue {
                caracteristiques.append(caract.stringValue)
            }
            
            let product = Product(id: id,
                                category: category,
                                   model: model,
                                   price: price,
                                imageURL: imageURL,
                        caracteristiques: caracteristiques)
                        self.products.append(product)
        }
        //self.downloadProductsImages()
    }
    
    func downloadProductsImages() {
        for product in self.products {
            let imageURL = product.imageURL
            let imageView = UIImageView()
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                imageView.downloadedFrom(link: imageURL, contentMode: UIViewContentMode.ScaleAspectFit)
                self.productsImagesViews.append(imageView)
            }
        }
    }
}