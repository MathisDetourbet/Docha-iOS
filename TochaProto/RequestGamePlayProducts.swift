//
//  RequestGamePlayProducts.swift
//  DochaProto
//
//  Created by Mathis D on 10/03/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class RequestGamePlayProducts {
    
   /* func getGamePlayProducts() -> [Product?] {
        var productsList: [Product?] = []
        Alamofire.request(.GET, "https://intense-atoll-44238.herokuapp.com/products.json")
            .responseJSON { response in
                print("Request : \(response.request!)")
                print("Response : \(response.response!)")
                print("Data : \(response.data!)")
                print("Result : \(response.result)")
                
                if let json = response.result.value {
                    print("JSON : \(json)")
                    
                    if let jsonArray = json as? Array<Dictionary<String, String>> {
                        for var product in jsonArray {
                            //let item = Product(id: Int(product["id"]!)!, name: product["name"]!, price: Double(product["price"]!)!, imageName: "goprohero", brand: product["brand"]!, distributeur: "")
                            //productsList.append(item)
                        }
                    }
                }
                
        }
        return productsList
    }*/
    
//    func parseGamePlayProductsWithResponse(json :AnyObject) -> [Product] {
//        var productsList: [Product] = []
//        
//        return productsList
//    }
}