//
//  CategoryRequest.swift
//  Docha
//
//  Created by Mathis D on 03/10/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class CategoryRequest: DochaRequest {
    
    func getAllCategories(withAuthToken authToken: String!, success: @escaping (_ categoriesArray: [Category]) -> Void, fail failure: @escaping (_ error: Error?) -> Void) {
        
        let urlString = Constants.UrlServer.UrlBase + Constants.UrlServer.UrlCategory.UrlAllCategory
        debugPrint("URL GET All Category : \(urlString)")
        
        alamofireManager!.adapter = AccessTokenAdapter(accessToken: authToken)
        alamofireManager!.request(urlString, method: .get, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                
                guard response.result.isSuccess else {
                    failure(response.result.error)
                    return
                }
                
                let jsonResponse = JSON(response.result.value)
                var categoriesList: [Category] = []
                
                for (_ ,subJson):(String, JSON) in jsonResponse {
                    let name = subJson[CategoryDataKey.kName].string
                    let slugName = subJson[CategoryDataKey.kSlugName].string
                    
                    if let name = name, let slugName = slugName {
                        let category = Category(name: name, slugName: slugName)
                        categoriesList.append(category)
                    }
                }
                
                if categoriesList.isEmpty {
                    failure(DochaRequestError.categoryNotFound)
                    
                } else {
                    success(categoriesList)
                }
            }
    }
    
    func get(category categorySlugName: String!, andAuthToken authToken: String!, success: @escaping (_ category: Category) -> Void, fail failure: @escaping (_ error: Error?) -> Void) {
        
        let urlString = Constants.UrlServer.UrlBase + Constants.UrlServer.UrlCategory.UrlGetCategory + "/" + categorySlugName
        debugPrint("URL GET All Category : \(urlString)")
        
        alamofireManager!.adapter = AccessTokenAdapter(accessToken: authToken)
        alamofireManager!.request(urlString, method: .get, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                
                guard response.result.isSuccess else {
                    failure(response.result.error)
                    return
                }
                
                let jsonResponse = JSON(response.result.value)
                let name = jsonResponse[CategoryDataKey.kName].string
                let slugName = jsonResponse[CategoryDataKey.kSlugName].string
                
                if let name = name, let slugName = slugName {
                    let category = Category(name: name, slugName: slugName)
                    success(category)
                    
                } else {
                    failure(DochaRequestError.categoryNotFound)
                }
            }
    }
    
}
