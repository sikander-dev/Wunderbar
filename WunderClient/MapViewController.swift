//
//  MapViewController.swift
//  WunderClient
//
//  Created by sikander on 8/17/18.
//  Copyright © 2018 sikander. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import GooglePlaces
import CoreData

class MapViewController: UIViewController, CLLocationManagerDelegate,
NSFetchedResultsControllerDelegate, GMSMapViewDelegate {
    
    private let locationManager = CLLocationManager()
    private let defaultLatitude = 53.5
    private let defaultLongitude = 10.0
    private let defaultZoomLevel: Float = 15.0
    
    private let fetchedResultsController: NSFetchedResultsController<Placemark>
    private let moc: NSManagedObjectContext
    
    lazy var mapView: GMSMapView = {
        let camera = GMSCameraPosition.camera(withLatitude: defaultLatitude,
                                              longitude: defaultLongitude,
                                              zoom: defaultZoomLevel)
        return GMSMapView.map(withFrame: view.bounds, camera: camera)
    }()
    
    private var markers: [GMSMarker] = []
    
    init(moc: NSManagedObjectContext) {
        self.moc = moc
        let fetchRequest: NSFetchRequest<Placemark> = NSFetchRequest(entityName: Placemark.entityName())
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: moc,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        super.init(nibName: nil, bundle: nil)
        fetchedResultsController.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLocationManager()
        configureMapView()
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            NSLog("Error while performing fetch: \(error)")
        }
        
        enableLocationServices()
        updateMarkers()
        updateCamera()
    }
    
    private func configureLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
    private func configureMapView() {
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        view.addSubview(mapView)
    }
    
    private func updateMarkers() {
        let placemarks = fetchedResultsController.fetchedObjects ?? []
        markers.removeAll()
        for placemark in placemarks {
            if let name = placemark.name,
                let latitude = placemark.latitude,
                let longitude = placemark.longitude {
                let marker = getMarker(withLatitude: latitude,
                                       longitude: longitude,
                                       name: name)
                marker.map = mapView
                markers.append(marker)
            }
        }
    }
    
    private func updateCamera() {
        if let placemark = fetchedResultsController.fetchedObjects?.first,
            let latitude = placemark.latitude,
            let longitude = placemark.longitude {
            let cameraPosition = GMSCameraPosition.camera(withLatitude: latitude,
                                                          longitude: longitude,
                                                          zoom: defaultZoomLevel)
            mapView.animate(to: cameraPosition)
        }
    }
    
    private func getMarker(withLatitude latitude: Double,
                           longitude: Double,
                           name: String) -> GMSMarker {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude,
                                                 longitude: longitude)
        marker.title = name
        // Did not use this asset as the marker clutering was not looking good
        //marker.icon = UIImage(named: "CarIcon")
        return marker
    }
    
    private func enableLocationServices() {
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
            
        case .restricted, .denied:
            break
            
        case .authorizedWhenInUse:
            break
            
        case .authorizedAlways:
            break
        }
    }
    
    // MARK: CLLocationManagerDelegate
    
    // MARK: GMSMapViewDelegate
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if mapView.selectedMarker != nil {
            markers.forEach {
                $0.map = mapView
            }
        } else {
            mapView.clear()
            marker.map = mapView
        }
        return false
    }
    
    // MARK: NSFetchedResultsControllerDelegate
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateMarkers()
        updateCamera()
    }
    
}
