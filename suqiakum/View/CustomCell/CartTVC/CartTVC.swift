//
//  CartTVC.swift
//  suqiakum
//
//  Created by Hady Hammad on 3/9/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import UIKit

class CartTVC: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var productPriceLbl: UILabel!
    @IBOutlet weak var productQuantityLbl: UILabel!
    @IBOutlet weak var increaseBtn: UIButton!
    @IBOutlet weak var decreaseBtn: UIButton!
    @IBOutlet weak var totalPriceLbl: UILabel!
    @IBOutlet weak var productView: UIView!
    
    var counterItem = 1
    var product:Item?
    var delegate:ChangePriceDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        productImage.addCornerRadius(productImage.frame.height / 2)
        productView.addCornerRadius(productView.frame.height / 2)
        productView.addBorderWith(width: 0.3, color: UIColor.darkGray)
    }
    
    func configure(item: Item) {
        self.product = item
        guard let imgURL = item.product_image, let qnt = item.quantity, let priceString = item.price, let price = Double(priceString) else{return}
        self.counterItem = qnt
        self.productNameLbl.text = item.product_name
        self.productQuantityLbl.text = "\(qnt)"
        self.productPriceLbl.text = "x \(price)"
        self.totalPriceLbl.text = "\(Float(price * Double(qnt))) ر.س"
        self.productImage.setImage(imageUrl: imgURL)
    }
    
    @IBAction func increase(_ sender: Any) {
        guard let id = self.product?.id,
            let priceString = self.product?.price,
            let price = Double(priceString) else{return}
        
        self.counterItem += 1
        self.productQuantityLbl.text = "\(self.counterItem)"
        self.totalPriceLbl.text = "\(Float(price * Double(counterItem))) ر.س"
        if delegate != nil{
            delegate?.changePrice(price: price)
        }
        
        let param:[String:Any] = ["product_id": id]
        NetworkApi.sendRequest(method: .post, url: cart, parameters: param, header: authentication, completion: { (err,status,response: CartResponse?) in
            
        })
    }
    
    @IBAction func decrease(_ sender: Any) {
        guard let id = self.product?.id,
            let priceString = self.product?.price,
            let price = Double(priceString) else{return}
        if counterItem > 1{
            self.counterItem -= 1
            self.productQuantityLbl.text = "\(self.counterItem)"
            self.totalPriceLbl.text = "\(Float(price * Double(counterItem))) ر.س"
            if delegate != nil{
                delegate?.changePrice(price: -price)
            }
            
            let param:[String:Any] = ["product_id": id]
            NetworkApi.sendRequest(method: .post, url: decreaseCart, parameters: param, header: authentication, completion: { (err,status,response: CartResponse?) in
                
            })
        }
    }
    
}
