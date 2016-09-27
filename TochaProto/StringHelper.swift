//
//  StringHelper.swift
//  Docha
//
//  Created by Mathis D on 09/06/2016.
//  Copyright © 2016 LaTV. All rights reserved.
//

import Foundation

extension String {
    subscript(integerIndex: Int) -> Character {
        let index = characters.index(startIndex, offsetBy: integerIndex)
        return self[index]
    }
    
    subscript(integerRange: Range<Int>) -> String {
        let start = characters.index(startIndex, offsetBy: integerRange.lowerBound)
        let end = characters.index(startIndex, offsetBy: integerRange.upperBound)
        let range = start..<end
        return self[range]
    }
}
