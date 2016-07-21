//
//  PriceRecordsRequest.swift
//  Docha
//
//  Created by Mathis D on 21/07/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class PriceRecordsRequest {
    
    func createPriceRecordWithUserID(userID: Int, productID: Int, psyPrice: Int, success: (() -> Void), fail failure: (error: NSError?, listErrors: [AnyObject]?) -> Void) {
        
        let userSession = UserSessionManager.sharedInstance.currentSession()!
        
        let parameters = [Constants.DataRecordsKey.kDataRecordUserID    : userID,
                          Constants.DataRecordsKey.kDataRecordProductID : productID,
                          Constants.DataRecordsKey.kDataRecordPsyPrice  : psyPrice,
                          Constants.UserDefaultsKey.kUserInfosEmail     : userSession.email!,
                          Constants.UserDefaultsKey.kUserInfosAuthToken : userSession.authToken!]
        let url = Constants.UrlServer.UrlBase + Constants.UrlServer.UrlDataRecords.UrlPriceRecords + ".json"
        print("URL POST Psy price record : \(url)")
        
        Alamofire.request(.POST, url, parameters: parameters as? [String : AnyObject], encoding: .JSON)
            .validate()
            .responseJSON { (response) in
                let statusCode = (response.response?.statusCode)! // Gets HTTP status code, useful for debugging
                print("Status code : \(statusCode)")
                if statusCode == 201 || statusCode == 200 {
                    if let value: AnyObject = response.result.value {
                        let jsonResponse = JSON(value)
                        print(jsonResponse)
                    }

                    success()
                } else {
                    failure(error: nil, listErrors: nil)
                }
        }

    }
}