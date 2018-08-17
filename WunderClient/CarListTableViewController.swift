//
//  CarListTableViewController.swift
//  WunderClient
//
//  Created by sikander on 8/16/18.
//  Copyright © 2018 sikander. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CarListTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    private let navigationTitle = "WUNDER CARS"
    private let cellNibName = "CarListTableViewCell"
    private let cellIdentifier = "PlacemarkCell"
    
    private let fetchedResultsController: NSFetchedResultsController<Placemark>
    private let moc: NSManagedObjectContext
    
    init(moc: NSManagedObjectContext) {
        self.moc = moc
        let fetchRequest: NSFetchRequest<Placemark> = NSFetchRequest(entityName: Placemark.entityName())
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: moc,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        super.init(style: .plain)
        fetchedResultsController.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = navigationTitle
        let nib = UINib(nibName: cellNibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
        do {
            try fetchedResultsController.performFetch()
        } catch {
            NSLog("Error while performing fetch: \(error)")
        }
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let text = fetchedResultsController.object(at: indexPath).address
        let margin: CGFloat = 16
        let padding: CGFloat = 8
        let imageViewWidth: CGFloat = 20
        let widthOtherThanAddressLabel: CGFloat = 2 * margin + padding + imageViewWidth
        let addressLabelHeight = text?.height(withConstrainedWidth: tableView.frame.width - widthOtherThanAddressLabel,
                                       font: UIFont.systemFont(ofSize: 16)) ?? 0
        let fixedCellHeight: CGFloat = 140
        return fixedCellHeight + addressLabelHeight
    }
    
    // MARK: UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                       for: indexPath) as? CarListTableViewCell
            else {
                fatalError("Unable to dequeue cell for identifier: \(cellIdentifier)")
        }
        let placemark = fetchedResultsController.object(at: indexPath)
        if let name = placemark.name,
            let vin = placemark.vin,
            let engineType = placemark.engineType,
            let interior = placemark.interior,
            let exterior = placemark.exterior,
            let address = placemark.address {
            cell.set(name: name,
                     vin: vin,
                     engineType: engineType,
                     fuel: placemark.fuel,
                     interior: interior,
                     exterior: exterior,
                     address: address)
        } else {
            NSLog("One of the required attributes in nil in placemark: \(placemark.debugDescription)")
        }
        return cell
    }
    
    // MARK: NSFetchedResultsControllerDelegate
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView?.reloadData()
    }
    
}
