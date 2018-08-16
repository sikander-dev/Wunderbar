//
//  ArrayExtensions.swift
//  WunderClient
//
//  Created by sikander on 8/16/18.
//  Copyright © 2018 sikander. All rights reserved.
//

import Foundation

extension Array {
    
    func splitBy(subSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: subSize).map {
            (startIndex: Int) in
            let endIndex = Swift.min(startIndex + subSize, count)
            return Array(self[startIndex ..< endIndex])
        }
    }
    
}
