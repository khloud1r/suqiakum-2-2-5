//
//  DeliveryTimeTVC.swift
//  suqiakum
//
//  Created by Hady Hammad on 3/9/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import UIKit

class DeliveryTimeTVC: UITableViewCell {

    @IBOutlet weak var deliveryTimeView: UIView!
    @IBOutlet weak var deliveryTimeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        deliveryTimeView.addCornerRadius(8)
        deliveryTimeView.addNormalShadow()
    }
    
    func configure(time: Time) {
        self.deliveryTimeLbl.text = time.time
    }
}
