//
//  NSManagedObjectExtensions.swift
//  WunderClient
//
//  Created by sikander on 8/15/18.
//  Copyright © 2018 sikander. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {
    
    static func entityName() -> String {
        let string = String(describing: self)
        return string
    }
    
    static func insertNewObject<T: NSManagedObject>(entity: T.Type,
                                                    moc: NSManagedObjectContext) -> T? {
        return NSEntityDescription.insertNewObject(forEntityName: entityName(),
                                                   into: moc) as? T
    }
    
    static func fetchObjects<T: NSManagedObject>(entity: T.Type,
                                                 predicate: NSPredicate?,
                                                 moc: NSManagedObjectContext) -> [T] {
        let request = NSFetchRequest<T>(entityName: entityName())
        request.predicate = predicate
        do {
            let matchedObjects = try moc.fetch(request)
            return matchedObjects
        } catch {
            NSLog("Error: \(error) while fetching objects with request \(request)")
            return []
        }
    }
    
}
