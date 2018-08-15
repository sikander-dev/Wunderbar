//
//  Placemark+CoreDataProperties.swift
//  WunderClient
//
//  Created by sikander on 8/15/18.
//  Copyright © 2018 sikander. All rights reserved.
//
//

import Foundation
import CoreData


extension Placemark {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Placemark> {
        return NSFetchRequest<Placemark>(entityName: "Placemark")
    }

    @NSManaged public var address: String?
    @NSManaged public var coordinates: [Double]
    @NSManaged public var engineType: String?
//    @NSManaged public var interior: Int16
//    @NSManaged public var exterior: Int16
    @NSManaged public var name: String?
    @NSManaged public var vin: String?
    @NSManaged public var fuel: Int32

}
