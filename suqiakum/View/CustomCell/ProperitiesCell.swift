//
//  ProperitiesCell.swift
//  suqiakum
//
//  Created by Hady Hammad on 3/20/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import UIKit

class ProperitiesCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var valueLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(properity: Properity?){
        self.nameLbl.text = properity?.name ?? ""
        self.valueLbl.text = properity?.value ?? ""
    }
    
}
