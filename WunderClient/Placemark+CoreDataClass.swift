//
//  Placemark+CoreDataClass.swift
//  WunderClient
//
//  Created by sikander on 8/15/18.
//  Copyright © 2018 sikander. All rights reserved.
//
//

import Foundation
import CoreData


public class Placemark: NSManagedObject {
    
    var interior: BodyQuality? {
        set {
            if let interiorQuality = newValue {
                let key = "interior"
                willChangeValue(forKey: key)
                setPrimitiveValue(interiorQuality.intValue,
                                  forKey: key)
                didChangeValue(forKey: key)
            }
        }
        get {
            let key = "interior"
            willAccessValue(forKey: key)
            defer {
                didAccessValue(forKey: key)
            }
            if let result = primitiveValue(forKey: key) as? Int16 {
                return BodyQuality.get(intValue: result)
            } else {
                return nil
            }
        }
    }
    
    var exterior: BodyQuality? {
        set {
            if let exteriorQuality = newValue {
                let key = "exterior"
                willChangeValue(forKey: key)
                setPrimitiveValue(exteriorQuality.intValue,
                                  forKey: key)
                didChangeValue(forKey: key)
            }
        }
        get {
            let key = "exterior"
            willAccessValue(forKey: key)
            defer {
                didAccessValue(forKey: key)
            }
            if let result = primitiveValue(forKey: key) as? Int16 {
                return BodyQuality.get(intValue: result)
            } else {
                return nil
            }
        }
    }
    
    var latitude: Double? {
        get {
            if coordinates.count >= 2 {
                return coordinates[1]
            } else {
                return nil
            }
        }
    }
    
    var longitude: Double? {
        get {
            return coordinates.first
        }
    }
    
    static func getOrCreate(vin: String,
                            name: String,
                            address: String,
                            coordinates: [Double],
                            fuel: Int32,
                            interior: BodyQuality,
                            exterior: BodyQuality,
                            engineType: String,
                            moc: NSManagedObjectContext) -> Placemark? {
        
        if let placemark = Placemark.get(vin: vin,
                                         moc: moc) {
            placemark.name = name
            placemark.address = address
            placemark.coordinates = coordinates
            placemark.fuel = fuel
            placemark.interior = interior
            placemark.exterior = exterior
            placemark.engineType = engineType
            return placemark
        } else {
            let newPlacemark = create(vin: vin,
                                      name: name,
                                      address: address,
                                      coordinates: coordinates,
                                      fuel: fuel,
                                      interior: interior,
                                      exterior: exterior,
                                      engineType: engineType,
                                      moc: moc)
            return newPlacemark
        }
        
    }
    
    static func get(vin: String,
                    moc: NSManagedObjectContext) -> Placemark? {
        let predicate = NSPredicate(format: "vin = %@", argumentArray: [vin])
        return fetchObjects(entity: self,
                            predicate: predicate,
                            moc: moc).first
    }
    
    static private func create(vin: String,
                               name: String,
                               address: String,
                               coordinates: [Double],
                               fuel: Int32,
                               interior: BodyQuality,
                               exterior: BodyQuality,
                               engineType: String,
                               moc: NSManagedObjectContext) -> Placemark? {
        
        NSLog("Creating new placemark in core data with vin: \(vin)")
        
        if let newPlacemark = insertNewObject(entity: self,
                                              moc: moc) {
            newPlacemark.vin = vin
            newPlacemark.name = name
            newPlacemark.address = address
            newPlacemark.coordinates = coordinates
            newPlacemark.fuel = fuel
            newPlacemark.interior = interior
            newPlacemark.exterior = exterior
            newPlacemark.engineType = engineType
            return newPlacemark
        } else {
            NSLog("Unable to create placemark for vin: \(vin)")
            return nil
        }
    }
    
}
