//
//  WishlistTVC.swift
//  suqiakum
//
//  Created by Hady Hammad on 3/20/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import UIKit

class WishlistTVC: UITableViewCell {

    @IBOutlet weak var productView: UIView!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var companyNameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var oldPriceView: UIView!
    @IBOutlet weak var oldPriceLbl: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productImgView: UIView!
    @IBOutlet weak var addToCartBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var saleView: UIView!
    @IBOutlet weak var saleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupComponent()
    }
    
    func setupComponent() {
        addToCartBtn.addBtnCornerRadius(8)
        deleteBtn.addBtnCornerRadius(8)
        productView.addNormalShadow()
        productImage.addCornerRadius(productImage.frame.height / 2)
        productImgView.addCornerRadius(productImgView.frame.height / 2)
        productImgView.addBorderWith(width: 0.3, color: UIColor.darkGray)
    }
    
    func configure(product: Details){
        guard let priceString = product.price,
            let newPriceString = product.new_price,
            let img = product.image,
            let price = Double(priceString),
            let newPrice = Double(newPriceString) else{return}
        
        self.productNameLbl.text = product.name
        DispatchQueue.main.async {
            self.productImage.setImage(imageUrl: img)
        }
        
        if price == newPrice {
            self.priceLbl.text = "\(price) ر.س"
            self.oldPriceView.isHidden = true
            self.saleView.isHidden = true
        }else{
            self.oldPriceView.isHidden = false
            self.saleView.isHidden = false
            var sale:Double = 0
            sale = round((price - newPrice) / price * 100)
            self.saleLbl.text = "\(Int(sale))%"
            self.priceLbl.text = "\(newPrice) ر.س"
            self.oldPriceLbl.text = "\(price) ر.س"
        }
    }
    
}
