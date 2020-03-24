//
//  WishlistVC.swift
//  suqiakum
//
//  Created by Hady Hammad on 3/21/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import UIKit

class WishlistVC: BaseViewController {
    
    // MARK :- Instance
    static func instance () -> WishlistVC{
        let storyboard = UIStoryboard.init(name: "Product", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "WishlistVC") as! WishlistVC
    }
    
    // MARK :- Outlets
    @IBOutlet weak var tableView: UITableView!
    
    var wishlistArray = [Details]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerCellNib(cellClass: WishlistTVC.self)
        loadWishlist()
    }
    
    func loadWishlist() {
        self.showLoadingIndicator()
        NetworkApi.sendRequest(method: .get, url: GET_WHISHLIST, header: authentication, completion: { (err,status,response: WishlistResponse?) in
            self.hideLoadingIndicator()
            if err == nil{
                if status!{
                    guard let whishlistArray = response?.data else{return}
                    self.wishlistArray = whishlistArray
                    self.tableView.reloadData()
                }
                
            }
        })
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension WishlistVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wishlistArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as WishlistTVC
        cell.configure(product: self.wishlistArray[indexPath.row])
        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(buDeletePress(_:)), for: .touchUpInside)
        cell.addToCartBtn.tag = indexPath.row
        cell.addToCartBtn.addTarget(self, action: #selector(buAddToCartPress(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func buAddToCartPress(_ sender: UIButton) {
        guard let id = self.wishlistArray[sender.tag].id else{return}
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
    }
    
    @objc func buDeletePress(_ sender: UIButton) {
        guard let id = self.wishlistArray[sender.tag].id else{return}
        self.showLoadingIndicator()
        NetworkApi.sendRequest(method: .delete, url: WHISHLIST, parameters: ["product_id": id], header: authentication, completion: { (err, status, response: DeleteResponse?) in
            self.hideLoadingIndicator()
            if err == nil{
                if status!{
                    self.showAlertsuccess(title: "تم ازالة المنتج من المفضلات")
                    self.loadWishlist()
                }
            }
            
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = ProductDetailsVC.instance()
        detailVC.product = self.wishlistArray[indexPath.row]
        self.present(detailVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
}
