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
    
    func setRawValue<ValueType: RawRepresentable>(value: ValueType, forKey key: String)
    {
        willChangeValue(forKey: key)
        setPrimitiveValue(value.rawValue, forKey: key)
        didChangeValue(forKey: key)
    }
    
    func rawValueForKey<ValueType: RawRepresentable>(key: String) -> ValueType?
    {
        willAccessValue(forKey: key)
        let result = primitiveValue(forKey: key) as! ValueType.RawValue
        didAccessValue(forKey: key)
        return ValueType(rawValue: result)
    }
    
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
