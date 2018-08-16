//
//  StringExtensions.swift
//  WunderClient
//
//  Created by sikander on 8/17/18.
//  Copyright © 2018 sikander. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    func height(withConstrainedWidth width: CGFloat,
                font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width,
                                    height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: [.usesLineFragmentOrigin, .usesFontLeading],
                                            attributes: [NSAttributedStringKey.font: font],
                                            context: nil)
        return boundingBox.height
    }
    
}
