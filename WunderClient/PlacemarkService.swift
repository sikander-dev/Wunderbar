//
//  PlacemarkService.swift
//  WunderClient
//
//  Created by sikander on 8/16/18.
//  Copyright © 2018 sikander. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON
import Alamofire

struct PlacemarkResponse {
    let vin: String
    let name: String
    let address: String
    let interior: BodyQuality
    let exterior: BodyQuality
    let coordinates: [Double]
    let engineType: String
    let fuel: Int32
}


class PlacemarkService {
    
    struct Constants {
        static let placemarks = "placemarks"
        static let vin = "vin"
        static let name = "name"
        static let address = "address"
        static let interior = "interior"
        static let exterior = "exterior"
        static let coordinates = "coordinates"
        static let engineType = "engineType"
        static let fuel = "fuel"
    }
    
    private let batchSize = 100
    
    private let moc: NSManagedObjectContext
    
    private let urlString = "https://s3-us-west-2.amazonaws.com/wunderbucket/locations.json"
    
    init(moc: NSManagedObjectContext) {
        self.moc = moc
    }
    
    func fetchPlacemarks() {
        
        guard let url = URL(string: urlString) else {
            NSLog("Cannot make url from string: \(urlString)")
            return
        }
        
        Alamofire.request(url).validate().responseJSON(completionHandler: {
            [weak self]
            response in
            
            guard response.result.isSuccess else {
                NSLog("Error while fetching response: \(String(describing: response.result.error))")
                return
            }
            guard let jsonObject = response.result.value else {
                NSLog("Result value is nil")
                return
            }
            
            let json = JSON(jsonObject)
            NSLog("json: \(json)")
            
            let placemarkResponses = PlacemarkService.parse(placemarksJSON: json)
            self?.persist(placemarks: placemarkResponses)
        })
        
    }
    
    private func persist(placemarks: [PlacemarkResponse]) {
        
        placemarks.splitBy(subSize: batchSize).forEach({
            (placemarkBatch: [PlacemarkResponse]) in
            
            moc.perform {
                [weak self] in
                guard let strongSelf = self else {
                    NSLog("self is nil inside block")
                    return
                }
                placemarkBatch.forEach({
                    strongSelf.persist(placemark: $0)
                })
                _ = strongSelf.moc.trySave()
            }
            
        })
        
    }
    
    private func persist(placemark: PlacemarkResponse) {
        _ = Placemark.getOrCreate(vin: placemark.vin,
                                  name: placemark.name,
                                  address: placemark.address,
                                  coordinates: placemark.coordinates,
                                  fuel: placemark.fuel,
                                  interior: placemark.interior,
                                  exterior: placemark.exterior,
                                  engineType: placemark.engineType,
                                  moc: moc)
    }
    
    private static func parse(placemarksJSON json: JSON) -> [PlacemarkResponse] {
        guard let placemarks = json[Constants.placemarks].array else {
            NSLog("Top level Placemarks object not found in json: \(json)")
            return []
        }
        return placemarks.compactMap( { parse(placemarkJSON: $0) } )
    }
    
    private static func parse(placemarkJSON json: JSON) -> PlacemarkResponse? {
        
        guard let vin = json[Constants.vin].string,
            let name = json[Constants.name].string,
            let address = json[Constants.address].string,
            let interiorRawValue = json[Constants.interior].string,
            let interior = BodyQuality(rawValue: interiorRawValue),
            let exteriorRawValue = json[Constants.exterior].string,
            let exterior = BodyQuality(rawValue: exteriorRawValue),
            let coordinates = json[Constants.coordinates].arrayObject as? [Double],
            let engineType = json[Constants.engineType].string,
            let fuel = json[Constants.fuel].int32 else {
                NSLog("One of the required attributes not found in placemark: \(json)")
                return nil
        }
        
        return PlacemarkResponse(vin: vin,
                                 name: name,
                                 address: address,
                                 interior: interior,
                                 exterior: exterior,
                                 coordinates: coordinates,
                                 engineType: engineType,
                                 fuel: fuel)
        
    }
    
}
