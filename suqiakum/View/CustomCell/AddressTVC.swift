//
//  AddressTVC.swift
//  suqiakum
//
//  Created by HadyHammad on 3/12/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import UIKit

class AddressTVC: UITableViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var addressNameLbl: UILabel!
    @IBOutlet weak var titleNameLbl: UILabel!
    @IBOutlet weak var editOrdeleteStack: UIStackView!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var leftArrowBtn: UIButton!
    
    var leftMenu = true
    override func awakeFromNib() {
        super.awakeFromNib()
        //backView.addBorderWith(width: 0.5, color: UIColor(red: 169/255, green: 169/255, blue: 169/255, alpha: 1))
        backView.addCornerRadius(5)
    }
    
    func configure(address: Address) {
        guard let is_default = address.is_default else{return}
        if is_default == 1{
            self.addressNameLbl.textColor = UIColor(red: 36/255, green: 99/255, blue: 255/255, alpha: 1)
            self.titleNameLbl.textColor = UIColor(red: 36/255, green: 99/255, blue: 255/255, alpha: 1)
        }else{
            self.addressNameLbl.textColor = UIColor(red: 146/255, green: 146/255, blue: 146/255, alpha: 1)
            self.titleNameLbl.textColor = UIColor(red: 146/255, green: 146/255, blue: 146/255, alpha: 1)
        }
        if let titleName = address.name{
            self.titleNameLbl.text = titleName
        }
        
        if let desc = address.description {
            self.addressNameLbl.text = desc
        }
    }
    
    @IBAction func buMenu(_ sender: Any) {
        if leftMenu{
            self.editOrdeleteStack.isHidden = false
            self.leftArrowBtn.setImage(UIImage(named: "keyboard_arrow_down"), for: .normal)
            leftMenu = false
        }else{
            self.editOrdeleteStack.isHidden = true
            self.leftArrowBtn.setImage(UIImage(named: "keyboard_arrow_left"), for: .normal)
            leftMenu = true
        }
    }
    
}
