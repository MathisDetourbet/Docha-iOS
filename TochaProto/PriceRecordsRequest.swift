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

class PriceRecordsRequest: DochaRequest {
    
    func createPriceRecordWithUserID(_ userID: Int, productID: Int, psyPrice: Int, isInIntervalle: Bool, responseTime: Double, hadTimeToGiveAnswer: Bool, success: @escaping (() -> Void), fail failure: @escaping (_ error: NSError?, _ listErrors: [AnyObject]?) -> Void) {
        
        let userSession = UserSessionManager.sharedInstance.currentSession()!
        
        let parameters = [Constants.DataRecordsKey.kDataRecordUserID                : userID,
                          Constants.DataRecordsKey.kDataRecordProductID             : productID,
                          Constants.DataRecordsKey.kDataRecordPsyPrice              : psyPrice,
                          Constants.DataRecordsKey.kDataRecordIsInIntervalle        : isInIntervalle,
                          Constants.DataRecordsKey.kDataRecordResponseTime          : responseTime,
                          Constants.DataRecordsKey.kDataRecordHadTimeToGiveAnswer   : hadTimeToGiveAnswer,
                          Constants.UserDefaultsKey.kUserInfosEmail                 : userSession.email!,
                          Constants.UserDefaultsKey.kUserInfosAuthToken             : userSession.authToken!] as [String : Any]
        
        let url = Constants.UrlServer.UrlBase + Constants.UrlServer.UrlDataRecords.UrlPriceRecords + ".json"
        print("URL POST Psy price record : \(url)")
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = REQUEST_TIME_OUT
        
        Alamofire.request(.POST, url, parameters: parameters as? [String: AnyObject], encoding: .json)
            .validate()
            .responseJSON { (response) in
                
                let statusCode = response.response?.statusCode // Gets HTTP status code, useful for debugging
                if let status = statusCode {
                    print("Status code : \(status)")
                    success()
                    
                } else {
                    failure(error: response.result.error, listErrors: nil)
                }
            }
    }
}
