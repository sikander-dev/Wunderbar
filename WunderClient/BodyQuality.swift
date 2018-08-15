//
//  BodyQuality.swift
//  WunderClient
//
//  Created by sikander on 8/15/18.
//  Copyright © 2018 sikander. All rights reserved.
//

import Foundation

enum BodyQuality: String {
    
    case good = "GOOD"
    case unacceptable = "UNACCEPTABLE"
    
    var intValue: Int16 {
        switch self {
        case .good:
            return 0
        case .unacceptable:
            return 0
        }
    }
    
    static func get(intValue: Int16) -> BodyQuality {
        switch intValue {
        case 0:
            return .good
        case 1:
            return .unacceptable
        }
    }
    
}


