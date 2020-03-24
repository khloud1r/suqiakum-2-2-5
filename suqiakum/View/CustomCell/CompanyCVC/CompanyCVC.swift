//
//  CompanyCVC.swift
//  suqiakum
//
//  Created by Hady Hammad on 3/18/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import UIKit

class CompanyCVC: UICollectionViewCell {
    
    @IBOutlet weak var companyView: UIView!
    @IBOutlet weak var companyImageView: UIImageView!
    @IBOutlet weak var CompanyNameLbl: UILabel!
    @IBOutlet weak var deliveryPriceLbl: UILabel!
    
    let firstTxt = "الحد الأدني"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.deliveryPriceLbl.adjustsFontSizeToFitWidth = true
        companyView.addNormalShadow()
        companyView.addCornerRadius(10)
        companyView.addBorderWith(width: 0.3, color: .lightGray)
        companyImageView.addCornerRadius(10)
    }
    
    func configure(company: Company) {
        if let deliveryPrice = company.min_amount {
            self.deliveryPriceLbl.text = firstTxt + " \(deliveryPrice) ر.س"
        }
        DispatchQueue.main.async {
            self.CompanyNameLbl.text = company.name
            if let img = company.image{
                self.companyImageView.setImage(imageUrl: img)
            }
        }
    }
}
