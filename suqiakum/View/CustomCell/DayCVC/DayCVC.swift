//
//  DayCVC.swift
//  suqiakum
//
//  Created by Hady Hammad on 3/9/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import UIKit

class DayCVC: UICollectionViewCell {
    
    @IBOutlet weak var dayView: UIView!
    @IBOutlet weak var dayNameLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dayView.addCornerRadius(5)
    }
    
    func configure(day: Day) {
        self.dayNameLbl.text = day.day
        self.dateLbl.text    = day.date
    }
}
