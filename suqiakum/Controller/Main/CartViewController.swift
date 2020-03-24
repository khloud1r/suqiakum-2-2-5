//
//  CartViewController.swift
//  suqiakum
//
//  Created by hany karam on 3/3/20.
//  Copyright © 2020 hany karam. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

protocol ChangePriceDelegate {
    func changePrice(price: Double)
}

class CartViewController: BaseViewController, ChangePriceDelegate {
    
    // MARK :- Instance
    static func instance () -> CartViewController{
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
    }
    
    // MARK :- Outlets
    @IBOutlet weak var completeOrderView: UIView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var totalPriceLbl: UILabel!
    @IBOutlet weak var companyNameLbl: UILabel!
    @IBOutlet var deleteAlertView: UIView!
    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet weak var noBtn: UIButton!
    @IBOutlet weak var priceRemainLbl: UILabel!
    @IBOutlet weak var freeDeliveryView: UIView!
    @IBOutlet weak var orderPriceLbl: UILabel!
    
    // MARK :- Instance Variables
    var items:[Item] = []
    var lastText = " لتحصل علي توصيل مجاني"
    var firstText = "اضف مزيدا من المنتجات بقيمة "
    var deliveryText = "الحد الأدني لقيمة المنتجات "
    var requiredDeliveryPrice:Int?
    
    // MARK :- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupComponent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let _ =  NetworkHelper.getIsLogIn() {
            loadCart()
        }else{
            self.showAlertWiring(title: "يجب عليك تسجيل حساب للمتابعة")
            present(LoginVC.instance(), animated: true, completion: nil)
        }
    }
 


    func setupComponent(){
        deleteAlertView.addCornerRadius(8)
        deleteAlertView.addBorderWith(width: 0.2, color: .blue)
        deleteAlertView.addNormalShadow()
        yesBtn.addBtnCornerRadius(15)
        noBtn.addBtnCornerRadius(15)
        yesBtn.addBtnBorderWith(width: 0.5, color: UIColor(red: 36/255, green: 99/255, blue: 145/255, alpha: 1))
        noBtn.addBtnBorderWith(width: 0.5, color: UIColor(red: 255/255, green: 191/255, blue: 42/255, alpha: 1))
        completeOrderView.addCornerRadius(8)
        completeOrderView.addBorderWith(width: 1, color: UIColor(red: 36/255, green: 99/255, blue: 255/255, alpha: 1))
        completeOrderView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(completeTapped)))
        tableview.registerCellNib(cellClass: CartTVC.self)
        tableview.reloadData()
    }
    
    func changePrice(price: Double) {
        if let totalPrice = Double(self.totalPriceLbl.text!) {
            self.totalPriceLbl.text = "\(Float(totalPrice+price))"
        }
    }
    
    func loadCart() {
        self.totalPriceLbl.text = "0.0"
        self.showLoadingIndicator()
        NetworkApi.sendRequest(method: .get, url: cart, header: authentication, completion: { (err,status,response: CartResponse?) in
            self.hideLoadingIndicator()
            if err == nil{
                if status!{
                    guard let message = response?.message else{return}
                    if message == "User cart Found!" {
                        guard let items = response?.data else{return}
                        if items.count != 0{
                            self.setupCompany(item: items[0])
                        }
                        self.items = items
                        self.tableview.reloadData()
                    }else{
                        self.showAlertWiring(title: message)
                    }
                }
            }
        })
    }
    
    func setupCompany(item: Item) {
        if let company = item.company{
            if company.has_free_delivery! == 1 {
                self.freeDeliveryView.isHidden = false
                self.priceRemainLbl.text = self.firstText + "\(company.min_delivery_amount ?? 0)" + self.lastText
            }else{
                self.freeDeliveryView.isHidden = true
            }
            self.orderPriceLbl.text = self.deliveryText + "\(company.min_amount ?? 0)" + " ر.س"
            self.requiredDeliveryPrice = company.min_amount
            self.companyNameLbl.text = company.name
        }
    }
    
    @objc func completeTapped(){
        if let totalPrice = Double(totalPriceLbl.text!), let requiredDeliveryPrice = self.requiredDeliveryPrice{
            if totalPrice >= Double(requiredDeliveryPrice) {
                let nav = UINavigationController(rootViewController: OrderVC.instance())
                present(nav, animated: true, completion: nil)
                self.totalPriceLbl.text = "\(0.0)"
            }else{
                self.showAlertWiring(title: "لم تتخطي الحد الادني للطلب")
            }
        }
    }
    
    @IBAction func buRemoveAllCart(_ sender: Any) {
        Show_Delete_View()
    }
    
    func Hide_Delete_View() {
        UIView.animate(withDuration: 0.3) {
            self.deleteAlertView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.deleteAlertView.alpha = 0
            self.deleteAlertView.removeFromSuperview()
        }
    }
    
    func Show_Delete_View() {
        self.view.addSubview(deleteAlertView)
        deleteAlertView.translatesAutoresizingMaskIntoConstraints = false
        deleteAlertView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        deleteAlertView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        deleteAlertView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        deleteAlertView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.97).isActive = true
        deleteAlertView.transform = CGAffineTransform.init(scaleX:  1.3, y: 1.3)
        deleteAlertView.alpha = 0
        UIView.animate(withDuration: 0.7) {
            self.deleteAlertView.alpha = 1
            self.deleteAlertView.transform = CGAffineTransform.identity
        }
    }
    
    @IBAction func buDeleteCancel(_ sender: Any) {
        Hide_Delete_View()
    }
    
    @IBAction func buDeleteConfirm(_ sender: Any) {
        self.showLoadingIndicator()
        NetworkApi.sendRequest(method: .post, url: emptyCart, header: authentication, completion: { (err, status, response: DeleteResponse?) in
            self.hideLoadingIndicator()
            if err == nil{
                if status!{
                    self.Hide_Delete_View()
                    self.loadCart()
                    self.showAlertsuccess(title: "تم تفريغ السلة بنجاح")
                }
            }
            
        })
    }
    
    @IBAction func back(_ sender: Any) {
        present(MainTabBar.instance(), animated: true, completion: nil)
    }
    
}

extension CartViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeue() as CartTVC
        cell.configure(item: items[indexPath.row])
        if let totalPrice = Double(self.totalPriceLbl.text!),
            let qnt = items[indexPath.row].quantity,
            let priceString = items[indexPath.row].price,
            let price = Double(priceString){
            let newPrice = price * Double(qnt)
            self.totalPriceLbl.text = "\(Float(totalPrice+newPrice))"
        }
 
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
