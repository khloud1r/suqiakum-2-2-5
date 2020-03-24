//
//  SearchProductCell.swift
//  suqiakum
//
//  Created by Hany Karam on 3/14/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import UIKit

class SearchProductCell: UITableViewCell {
    
    @IBOutlet weak var productView: UIView!
    @IBOutlet weak var productNameLbl: UILabel!
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
     var count = 0 {
        didSet {
            countLabel.text = "\(count)"
            counterStackView.isHidden = !(count > 0)
            addToCartBtn.isHidden = count > 0
        }
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        productView.addNormalShadow()
    }
    var product: Details?

  
    
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
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
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
