//
//  DetailsViewController.swift
//  suqiakum
//
//  Created by hany karam on 3/3/20.
//  Copyright © 2020 hany karam. All rights reserved.
//

import UIKit

class DetailsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK :- Instance
    static func instance () -> DetailsViewController{
        let storyboard = UIStoryboard.init(name: "Product", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
    }
    
    // MARK :- Outlets
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var priceRemainLbl: UILabel!
    @IBOutlet weak var freeDeliveryView: UIView!
    @IBOutlet weak var orderPriceLbl: UILabel!
    
    // MARK :- Instance Variables
    var counterItem = 0
    var item:Company?
    var details = [Details]()
    var lastText = " لتحصل علي توصيل مجاني"
    var firstText = "اضف مزيدا من المنتجات بقيمة "
    var deliveryText = "الحد الأدني لقيمة المنتجات "
    
    // MARK :- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.registerCellNib(cellClass: DetailsTVC.self)
        loadProducts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let company = item{
            if company.has_free_delivery! == 1 {
                self.freeDeliveryView.isHidden = false
                self.priceRemainLbl.text = self.firstText + "\(company.min_delivery_amount ?? 0)" + self.lastText
            }else{
                self.freeDeliveryView.isHidden = true
            }
            self.orderPriceLbl.text = self.deliveryText + "\(company.min_amount ?? 0)" + " ر.س"
            self.companyName.text = company.name
        }
    }
    
    func loadProducts() {
        guard let id = item?.id else { return }
        self.showLoadingIndicator()
        NetworkApi.sendRequest(method: .get, url: GET_PRODUCTS+"\(id)", header: authentication, completion: { (err,status,response: DetailsResponse?) in
            self.hideLoadingIndicator()
            if err == nil{
                if status!{
                    guard let productArray = response?.data?.data else{return}
                    self.details = productArray
                    self.tableview.reloadData()
                }
            }
        })
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return details.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as DetailsTVC
        cell.configure(product: details[indexPath.row])
        cell.companyNameLbl.text = item?.name
        cell.addToCartBtn.tag = indexPath.row
        cell.addToCartBtn.addTarget(self, action: #selector(buAddToCartPress(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func buAddToCartPress(_ sender: UIButton){
       print(sender.tag)
        let buttonPosition : CGPoint = (sender as AnyObject).convert((sender as AnyObject).bounds.origin, to: self.tableview)
        if let index = self.tableview {
            
            let indexPath = index.indexPathForRow(at: buttonPosition)
           
            let cell = tableview.cellForRow(at: indexPath!) as! DetailsTVC
            
            let imageViewPosition : CGPoint = cell.productImage.convert(cell.productImage.bounds.origin, to: self.view)
            addToCart(product: details[sender.tag])
            let imgViewTemp = UIImageView(frame: CGRect(x: imageViewPosition.x, y: imageViewPosition.y, width: cell.productImage.frame.size.width, height: cell.productImage.frame.size.height))
            
            imgViewTemp.image = cell.productImage.image
            
            animation(tempView: imgViewTemp)
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = ProductDetailsVC.instance()
        detailVC.product = self.details[indexPath.row]
        self.present(detailVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
    
    func addToCart(product: Details) {
        
        if let _ =  NetworkHelper.getIsLogIn() {
            
            guard let id = product.id else{return}
            self.showLoadingIndicator()
            NetworkApi.sendRequest(method: .post, url: cart, parameters: ["product_id": id], header: authentication, completion: { (err,status,response: CartResponse?) in
                self.hideLoadingIndicator()
                if err == nil{
                    guard let message = response?.message else{return}
                    if status!{
                        if message == "تم اضافة المنتج بنجاح" {
                            self.showAlertsuccess(title: message)
                        }
                    }else{
                        self.showAlertWiring(title: message)
                    }
                }else{
                    self.showAlertError(title: "غير قادر علي اتمام العملية")
                }
            })
            
        }else{
            self.showAlertWiring(title: "يجب عليك تسجيل حساب للمتابعة")
        }
        
    }
    
    func animation(tempView : UIView)  {
        self.view.addSubview(tempView)
        UIView.animate(withDuration: 1.0,
                       animations: {
                        tempView.animationZoom(scaleX: 1.5, y: 1.5)
        }, completion: { _ in
            
            UIView.animate(withDuration: 0.5, animations: {
                
                tempView.animationZoom(scaleX: 0.2, y: 0.2)
                tempView.animationRoted(angle: CGFloat(Double.pi))
                
 
            }, completion: { _ in
                
                tempView.removeFromSuperview()
                
                UIView.animate(withDuration: 1.0, animations: {
                    
                    self.counterItem += 1
                  }, completion: {_ in
                 })
                
            })
            
        })
    }
    
}
