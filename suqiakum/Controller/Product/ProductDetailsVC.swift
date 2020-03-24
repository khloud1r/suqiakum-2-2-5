//
//  ProductDetailsVC.swift
//  suqiakum
//
//  Created by Hady Hammad on 3/19/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import UIKit

class ProductDetailsVC: BaseViewController {
    
    // MARK :- Instance
    static func instance () -> ProductDetailsVC{
        let storyboard = UIStoryboard.init(name: "Product", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "ProductDetailsVC") as! ProductDetailsVC
    }
    
    // MARK :- Outlets
    @IBOutlet weak var percentBtn: UIButton!
    @IBOutlet weak var addToCartView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var oldPriceView: UIView!
    @IBOutlet weak var oldPriceLbl: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var saleView: UIView!
    @IBOutlet weak var saleLbl: UILabel!
    @IBOutlet weak var navProductNameLbl: UILabel!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var basketImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var propeitiesView: UIView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet var reportView: UIView!
    @IBOutlet weak var restoreBtn: UIButton!
    @IBOutlet weak var reportBtn: UIButton!
    @IBOutlet weak var complainView: UIView!
    @IBOutlet weak var notesView: UIView!
    @IBOutlet weak var notesTxtField: UITextField!
    @IBOutlet weak var favouriteBtn: UIButton!
    @IBOutlet weak var imgReportBtn: UIButton!
    @IBOutlet weak var priceReportBtn: UIButton!
    @IBOutlet weak var otherReportBtn: UIButton!
    @IBOutlet weak var infoImageView: UIImageView!
    @IBOutlet weak var increaseBtn: UIButton!
    @IBOutlet weak var decreaseBtn: UIButton!
    @IBOutlet weak var counterLbl: UILabel!
    @IBOutlet weak var cartCounterView: UIView!
    
    // MARK :- Instance Variables
    var product:Details?
    var reportTitle = "صورة المنتج غير واضحة"
    var wishlistArray = [Details]()
    var cartArray:[Item] = []
    var favorite = false
    
    // MARK :- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupComponent()
        setupProduct()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadWishlist()
        loadCart()
    }
    
    
    func setupComponent() {
        cartCounterView.addBorderWith(width: 0.3, color: UIColor(red: 255/255, green: 191/255, blue: 42/255, alpha: 1))
        let origImage = UIImage(named: "dialoge")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        infoImageView.image = tintedImage
        infoImageView.tintColor = .selectedBorderColor
        notesView.addCornerRadius(5)
        complainView.addCornerRadius(5)
        restoreBtn.addBtnCornerRadius(13)
        reportBtn.addBtnCornerRadius(13)
        reportView.addCornerRadius(8)
        propeitiesView.addCornerRadius(15)
        cancelBtn.addCornerRadius(13)
        topView.addNormalShadow()
        percentBtn.addCornerRadius(8)
        percentBtn.addBtnBorderWith(width: 1, color: UIColor(red: 55/255, green: 97/255, blue: 116/255, alpha: 1))
        addToCartView.addCornerRadius(8)
        addToCartView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addToCartTapped)))
    }
    
    func loadWishlist() {
        self.showLoadingIndicator()
        NetworkApi.sendRequest(method: .get, url: GET_WHISHLIST, header: authentication, completion: { (err,status,response: WishlistResponse?) in
            if err == nil{
                if status!{
                    guard let whishlistArray = response?.data else{return}
                    self.wishlistArray = whishlistArray
                    for product in self.wishlistArray {
                        if product.id == self.product!.id!{
                            self.favorite = true
                            self.favouriteBtn.setImage(UIImage(named: "favorite"), for: .normal)
                        }
                    }
                }
            }else{
                self.hideLoadingIndicator()
            }
        })
    }
    
    func loadCart() {
        NetworkApi.sendRequest(method: .get, url: cart, header: authentication, completion: { (err,status,response: CartResponse?) in
            self.hideLoadingIndicator()
            if err == nil{
                guard let message = response?.message else{return}
                if status!{
                    guard let items = response?.data else{return}
                    self.cartArray = items
                    for cartProduct in self.cartArray {
                        if cartProduct.id == self.product!.id!{
                            self.counterLbl.text = "\(cartProduct.quantity ?? 0)"
                            self.addToCartView.isHidden = true
                            self.cartCounterView.isHidden = false
                        }
                    }
                }else{
                    self.showAlertWiring(title: message)
                }
            }
        })
    }
    
    func setupProduct() {
        guard let priceString = product?.price,
            let newPriceString = product?.new_price,
            let img = product?.image,
            let price = Double(priceString),
            let newPrice = Double(newPriceString) else{return}
        
        self.productNameLbl.text = product?.name
        self.navProductNameLbl.text = product?.name
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
    
    func Hide_Properities_View() {
        self.shadowView.isHidden = true
        UIView.animate(withDuration: 0.4) {
            self.propeitiesView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.propeitiesView.alpha = 0
            self.propeitiesView.removeFromSuperview()
        }
    }
    
    func Show_Properities_View() {
        self.shadowView.isHidden = false
        self.view.addSubview(propeitiesView)
        propeitiesView.translatesAutoresizingMaskIntoConstraints = false
        propeitiesView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        propeitiesView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        propeitiesView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.7).isActive = true
        propeitiesView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.92).isActive = true
        propeitiesView.transform = CGAffineTransform.init(scaleX:  1.3, y: 1.3)
        propeitiesView.alpha = 0
        UIView.animate(withDuration: 0.7) {
            self.propeitiesView.alpha = 1
            self.propeitiesView.transform = CGAffineTransform.identity
        }
    }
    
    func Hide_Report_View() {
        UIView.animate(withDuration: 0.4) {
            self.reportView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.reportView.alpha = 0
            self.reportView.removeFromSuperview()
        }
    }
    
    func Show_Report_View() {
        self.view.addSubview(reportView)
        reportView.translatesAutoresizingMaskIntoConstraints = false
        reportView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        reportView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        reportView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.71).isActive = true
        reportView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.95).isActive = true
        reportView.transform = CGAffineTransform.init(scaleX:  1.3, y: 1.3)
        reportView.alpha = 0
        UIView.animate(withDuration: 0.7) {
            self.reportView.alpha = 1
            self.reportView.transform = CGAffineTransform.identity
        }
    }
    
    @objc func addToCartTapped() {
        guard let id = product?.id else{return}
        self.showLoadingIndicator()
        NetworkApi.sendRequest(method: .post, url: cart, parameters: ["product_id": id], header: authentication, completion: { (err,status,response: CartResponse?) in
            self.hideLoadingIndicator()
            if err == nil{
                guard let message = response?.message else{return}
                if status!{
                    if message == "تم اضافة المنتج بنجاح" {
                        self.addToCartView.isHidden = true
                        self.cartCounterView.isHidden = false
                        self.showAlertsuccess(title: message)
                    }
                }else{
                    self.showAlertWiring(title: message)
                }
            }else{
                self.showAlertError(title: "غير قادر علي اتمام العملية")
            }
        })
    }
    
    @IBAction func buIncrease(_ sender: Any) {
        guard let id = product?.id else{return}
        
        let counter = Int(self.counterLbl.text!)
        self.counterLbl.text = "\(counter! + 1)"
        
        NetworkApi.sendRequest(method: .post, url: cart, parameters: ["product_id": id], header: authentication, completion: { (err,status,response: CartResponse?) in
            
        })
    }
    
    @IBAction func buDecrease(_ sender: Any) {
        guard let id = product?.id else{return}
        
        let counter = Int(self.counterLbl.text!)
        if counter == 0{
            self.addToCartView.isHidden = false
            self.cartCounterView.isHidden = true
        }
        self.counterLbl.text = "\(counter! - 1)"
        
        NetworkApi.sendRequest(method: .post, url: decreaseCart, parameters: ["product_id": id], header: authentication, completion: { (err,status,response: CartResponse?) in
            
        })
    }
    
    @IBAction func buImageReport(_ sender: Any) {
        imgReportBtn.setImage(UIImage(named: "selected_circle"), for: .normal)
        priceReportBtn.setImage(UIImage(named: "unselected_circle"), for: .normal)
        otherReportBtn.setImage(UIImage(named: "selected_circle"), for: .normal)
        self.reportTitle = "صورة المنتج غير واضحة"
    }
    
    @IBAction func buPriceReport(_ sender: Any) {
        priceReportBtn.setImage(UIImage(named: "selected_circle"), for: .normal)
        imgReportBtn.setImage(UIImage(named: "unselected_circle"), for: .normal)
        otherReportBtn.setImage(UIImage(named: "unselected_circle"), for: .normal)
        self.reportTitle = "سعر المنتج غير صحيح"
    }
    
    @IBAction func buOtherReport(_ sender: Any) {
        otherReportBtn.setImage(UIImage(named: "selected_circle"), for: .normal)
        priceReportBtn.setImage(UIImage(named: "unselected_circle"), for: .normal)
        imgReportBtn.setImage(UIImage(named: "unselected_circle"), for: .normal)
        self.reportTitle = "أريد التبليغ عن شيئ أخر"
    }
    
    @IBAction func buFavourite(_ sender: Any) {
        guard let id = product?.id else{return}
        if favorite {
            
            self.showLoadingIndicator()
            NetworkApi.sendRequest(method: .delete, url: WHISHLIST, parameters: ["product_id": id], header: authentication, completion: { (err, status, response: DeleteResponse?) in
                self.hideLoadingIndicator()
                if err == nil{
                    if status!{
                        self.favorite = false
                        self.favouriteBtn.setImage(UIImage(named: "unfavorite"), for: .normal)
                        self.showAlertsuccess(title: "تم ازالة المنتج من المفضلات")
                    }
                }
                
            })
            
        }else{
            
            self.showLoadingIndicator()
            NetworkApi.sendRequest(method: .post, url: WHISHLIST, parameters: ["product_id": id], header: authentication, completion: { (err, status, response: DeleteResponse?) in
                self.hideLoadingIndicator()
                if err == nil{
                    if status!{
                        self.favorite = true
                        self.favouriteBtn.setImage(UIImage(named: "favorite"), for: .normal)
                        self.showAlertsuccess(title: "تم اضافة المنتج إلي المفضلات بنجاح")
                    }
                }
                
            })
            
        }
        
    }
    
    @IBAction func buConfirmReport(_ sender: Any) {
        
        if notesTxtField.text!.isEmpty{
            self.showAlertWiring(title: "يجب عليك ادخال نص الرسالة")
            return
        }
        
        let param  = [ "title": self.reportTitle,
                       "message": notesTxtField.text!]
        self.showLoadingIndicator()
        NetworkApi.sendRequest(method: .post, url: support, parameters: param, header: authentication, completion: { (err, status, response: SupportMessageResponse?) in
            self.hideLoadingIndicator()
            if err == nil{
                if status!{
                    self.showAlertsuccess(title: "تم الارسال بنجاح")
                    self.notesTxtField.text = nil
                }else{
                    self.showAlertWiring(title: "تأكد من صحة البيانات")
                }
            }
        })
        
    }
    
    @IBAction func buShowReport(_ sender: Any) {
        Show_Report_View()
    }
    
    @IBAction func buHideReport(_ sender: Any) {
        Hide_Report_View()
    }
    
    @IBAction func buShowCharacteristics(_ sender: Any) {
        Show_Properities_View()
    }
    
    @IBAction func buHideCharacteristics(_ sender: Any) {
        Hide_Properities_View()
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension ProductDetailsVC: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.product?.characteristics?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProperitiesCell", for: indexPath) as! ProperitiesCell
        cell.configure(properity: self.product?.characteristics?[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
}
