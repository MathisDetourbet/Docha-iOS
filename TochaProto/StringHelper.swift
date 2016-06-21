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
        let index = startIndex.advancedBy(integerIndex)
        return self[index]
    }
    
    subscript(integerRange: Range<Int>) -> String {
        let start = startIndex.advancedBy(integerRange.startIndex)
        let end = startIndex.advancedBy(integerRange.endIndex)
        let range = start..<end
        return self[range]
    }
}