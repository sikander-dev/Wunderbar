//
//  NSManagedObjectContextExtensions.swift
//  WunderClient
//
//  Created by sikander on 8/16/18.
//  Copyright © 2018 sikander. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    
    func trySave() -> Bool {
        guard self.hasChanges else { return false }
        
        do {
            try self.save()
        } catch {
            NSLog("Managed object context failed to save with error: \(error)")
            return false
        }
        
        return true
    }
    
}
