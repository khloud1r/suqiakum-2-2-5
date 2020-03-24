//
//  OrderCell.swift
//  suqiakum
//
//  Created by Hady Hammad on 3/24/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import UIKit

class OrderCell: UITableViewCell {
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var deliveryTimeLabel: UILabel!
    @IBOutlet weak var iconsStackView: UIStackView!
    @IBOutlet weak var labelsStackView: UIStackView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var detailView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupComponent()
    }
    
    func setupComponent() {
        backView.addBorderWith(width: 0.1, color: .lightGray)
        backView.addNormalShadow()
        detailView.addBorderWith(width: 0.5, color: .lightGray)
    }
    
    func configure(order: Order) {
        idLabel.text = "#\(order.id!)"
        companyNameLabel.text = order.company?.name
        deliveryTimeLabel.text = order.delivery_time
        
        // clean stackViews for dequeuing :
        iconsStackView.arrangedSubviews.forEach { (view) in
            view.removeFromSuperview()
        }
        labelsStackView.arrangedSubviews.forEach { (view) in
            view.removeFromSuperview()
        }
        
        order.statuses?.reversed().forEach({ (status) in
            let icon = UIImageView(image: status.is_active == 0 ? #imageLiteral(resourceName: "ic_status_success") : #imageLiteral(resourceName: "ic_status_done"))
            icon.contentMode = .scaleAspectFit
            iconsStackView.addArrangedSubview(icon)
            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
            label.textColor = #colorLiteral(red: 0.1512289941, green: 0.3855682313, blue: 0.4632771015, alpha: 1)
            label.font = UIFont(name: "Tajawal-Regular", size: 13)
            label.text = status.status
            label.textAlignment = .center
            labelsStackView.addArrangedSubview(label)
        })
        
    }
  
}

