//
//  ConverterHelper.swift
//  Docha
//
//  Created by Mathis D on 16/09/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

class ConverterHelper {
    
    class func convertPriceToArrayOfInt(_ price: Double!) -> (priceArray: [Int], centsString: String) {
        let string = String(price)
        let eurosAndCentsArray = string.characters.split{$0 == "."}.map(String.init)
        
        let eurosString = String(eurosAndCentsArray[0])
        let eurosArray = eurosString?.characters.flatMap{Int(String($0))}
        
        var centsString = String(eurosAndCentsArray[1])
        if centsString?.characters.count == 1 {
            centsString += "0"
        }
        
        return (eurosArray!, centsString!)
    }
    
    class func convertPriceArrayToInt(_ psyPriceArray: [Int]) -> Int {
        var psyPriceInt = 0
        let reversePsyPriceArray = Array(psyPriceArray.reversed())
        for index in 0...reversePsyPriceArray.count-1 {
            psyPriceInt += reversePsyPriceArray[index] * Int(pow(Double(10), Double(index)))
        }
        
        return psyPriceInt
    }
}
