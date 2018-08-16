//
//  CarListTableViewCell.swift
//  WunderClient
//
//  Created by sikander on 8/16/18.
//  Copyright © 2018 sikander. All rights reserved.
//

import Foundation
import UIKit

class CarListTableViewCell: UITableViewCell {
    
    private let vinText = "VIN : "
    private let engineText = "ENGINE TYPE : "
    private let fuelText = "FUEL : "
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var vinLabel: UILabel!
    @IBOutlet weak var engineLabel: UILabel!
    @IBOutlet weak var fuelLabel: UILabel!
    
    @IBOutlet weak var interiorImageView: UIImageView!
    @IBOutlet weak var exteriorImageView: UIImageView!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func set(name: String,
             vin: String,
             engineType: String,
             fuel: Int32,
             interior: BodyQuality,
             exterior: BodyQuality,
             address: String) {
        nameLabel.text = name
        vinLabel.text = vinText + vin
        engineLabel.text = engineText + engineType
        fuelLabel.text = fuelText + String(fuel)
        interiorImageView.image = getImage(for: interior)
        exteriorImageView.image = getImage(for: exterior)
        addressLabel.text = address
    }
    
    func getImage(for bodyQuality: BodyQuality) -> UIImage? {
        switch bodyQuality {
        case .good:
            return UIImage(named: "ThumbsUp")
        case .unacceptable:
            return UIImage(named: "ThumbsDown")
        }
    }
    
}
