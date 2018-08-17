//
//  ArrayExtensionsTests.swift
//  ArrayExtensionsTests
//
//  Created by sikander on 8/12/18.
//  Copyright © 2018 sikander. All rights reserved.
//

import XCTest
@testable import WunderClient

class ArrayExtensionsTests: XCTestCase {
    
    var array: [Int] = []
    
    func testSplitBy() {
        
        array = [1, 3, 5, 7, 9, 11, 13, 15]
        let message = "Array is split incorrectly"
        
        // subSize not a factor of size of array
        let fragmentsArray = array.splitBy(subSize: 3)
        let desiredFragmentsArray = [[1, 3, 5], [7, 9, 11], [13, 15]]
        XCTAssertEqual(fragmentsArray, desiredFragmentsArray, message)
        
        // subSize = Size of array
        XCTAssertEqual(array.splitBy(subSize: array.count), [array], message)
        
    }
    
}
