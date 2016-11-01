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
        
        let urlString = Constants.UrlServer.UrlBase + Constants.UrlServer.UrlCategory.UrlAllCategories
        debugPrint("URL GET All Category : \(urlString)")
        
        alamofireManager!.adapter = AccessTokenAdapter(accessToken: authToken)
        alamofireManager!.request(urlString, method: .get, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                
                guard response.result.isSuccess else {
                    failure(response.result.error)
                    return
                }
                
                let jsonResponse = JSON(response.result.value as Any)
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
                
                let jsonResponse = JSON(response.result.value as Any)
                let category = Category(jsonObject: jsonResponse)
                
                if let category = category {
                    success(category)
                    
                } else {
                    failure(DochaRequestError.categoryNotFound)
                }
            }
    }
    
    func postRenewCategories(withAuthtoken authToken: String!, forMatchID matchID: Int!, andRoundID roundID: Int!, success: @escaping (_ categories: [Category]) -> Void, fail failure: @escaping (_ error: Error?) -> Void) {
        
        let urlString = Constants.UrlServer.UrlBase + "/match/" + "\(matchID!)" + "/round/" + "\(roundID!)" + Constants.UrlServer.UrlCategory.UrlRenewCategies
        debugPrint("URL POST Renew Category : \(urlString)")
        
        alamofireManager!.adapter = AccessTokenAdapter(accessToken: authToken)
        alamofireManager!.request(urlString, method: .post, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                
                guard response.result.isSuccess else {
                    failure(response.result.error)
                    return
                }
                
                let jsonResponse = JSON(response.result.value as Any)
                var categoriesList: [Category] = []
                
                for categoryJson in jsonResponse[RoundDataKey.kProposedCategories].arrayValue {
                    let category = Category(jsonObject: categoryJson)
                    
                    if let category = category {
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
    
}
