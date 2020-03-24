//
//  DetailsTVC.swift
//  suqiakum
//
//  Created by Hady Hammad on 3/10/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import UIKit

class DetailsTVC: UITableViewCell {
    
    @IBOutlet weak var productView: UIView!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var companyNameLbl: UILabel!
    @IBOutlet weak var addToCartView: UIView!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var oldPriceView: UIView!
    @IBOutlet weak var oldPriceLbl: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productImgView: UIView!
    @IBOutlet weak var addToCartBtn: UIButton!
    @IBOutlet weak var saleView: UIView!
    @IBOutlet weak var saleLbl: UILabel!
 
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var counterStackView: UIStackView!

 

    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupComponent()
        
    }
    
    func setupComponent() {
        productView.addNormalShadow()
        productImage.addCornerRadius(productImage.frame.height / 2)
        productImgView.addCornerRadius(productImgView.frame.height / 2)
        productImgView.addBorderWith(width: 0.3, color: UIColor.darkGray)
        addToCartView.addCornerRadius(8)
        addToCartView.addBorderWith(width: 1, color: UIColor(red: 36/255, green: 99/255, blue: 255/255, alpha: 1))
    }
    var product: Details?
    var count = 0 {
        didSet {
            countLabel.text = "\(count)"
            counterStackView.isHidden = !(count > 0)
            addToCartBtn.isHidden = count > 0
        }
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
    @IBAction func addToCartButtonPressed(_ sender: Any) {
        
        let param:[String:Any] = ["product_id": self.product?.id]
        NetworkApi.sendRequest(method: .post, url: cart, parameters: param, header: authentication, completion: { (err,status,response: CartResponse?) in
            if status == true {
                self.count = 1
            }
        })
        
    }
    @IBAction func increaseButtonPressed(_ sender: Any) {
        self.count += 1
        
        let param:[String:Any] = ["product_id": self.product?.id]
        NetworkApi.sendRequest(method: .post, url: cart, parameters: param, header: authentication, completion: { (err,status,response: CartResponse?) in
            
        })
        
    }
    @IBAction func decreaseButtonPressed(_ sender: Any) {
        if self.count > 0 {
            self.count -= 1
            
            let param:[String:Any] = ["product_id": self.product!.id]
            NetworkApi.sendRequest(method: .post, url: decreaseCart, parameters: param, header: authentication, completion: { (err,status,response: CartResponse?) in
                
            })
            
        }
    }

}
