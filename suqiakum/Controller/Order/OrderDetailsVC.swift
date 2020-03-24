//
//  OrderDetailsVC.swift
//  suqiakum
//
//  Created by Hady Hammad on 3/24/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import UIKit
import Alamofire

class OrderDetailsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectionView: UIView!
    @IBOutlet weak var inProgressButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    
    var activityIndicatorView: UIActivityIndicatorView!
    
    
    var orders = [Order]() {
        didSet {
            orders.count > 0 ? activityIndicatorView.stopAnimating() : activityIndicatorView.startAnimating()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerCellNib(cellClass: OrderCell.self)
        tableView.tableFooterView = UIView()
        activityIndicatorView = UIActivityIndicatorView(style: .gray)
        activityIndicatorView.hidesWhenStopped = true
        tableView.backgroundView = activityIndicatorView
        activityIndicatorView.startAnimating()
        
        
        getOrders { (orders, error) in
            if let error = error {
                print("error getting orders: \(error.localizedDescription)")
            }
            if let orders = orders {
                self.orders = orders.data?.data ?? []
                self.tableView.reloadData()
            }
        }
        
    }
    
    
    func getOrders (completion:@escaping ( OrdersResponse? ,  Error?) -> Void) {
        guard let token = NetworkHelper.getAccessToken() else {
            print("can't get access token")
            return
        }
        
        let headers = ["content-type" : "application/json",
                       "Authorization" : "Bearer \(token)"]
        let url = "https://test.otc.net.sa/api/users/orders"
        
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            guard response.response?.statusCode == 200 else {
                completion(nil , response.error)
                return
            }
            switch response.result {
            case .success :
                do {
                    let responseModel = try JSONDecoder().decode(OrdersResponse.self, from: response.data!)
                    completion(responseModel, nil)
                } catch (let error) {
                    print(error)
                    completion(nil , error)
                }
            case .failure(let error) :
                print(error.localizedDescription)
                completion(nil , error)
            }
        }
    }
    
    func getOldOrders (completion:@escaping ( OrdersResponse? ,  Error?) -> Void) {
        guard let token = NetworkHelper.getAccessToken() else {
            print("can't get access token")
            return
        }
        
        let headers = ["content-type" : "application/json",
                       "Authorization" : "Bearer \(token)"]
        let url = "https://test.otc.net.sa/api/users/orders/old_orders"
        
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            guard response.response?.statusCode == 200 else {
                completion(nil , response.error)
                return
            }
            switch response.result {
            case .success :
                do {
                    let responseModel = try JSONDecoder().decode(OrdersResponse.self, from: response.data!)
                    completion(responseModel, nil)
                } catch (let error) {
                    print(error)
                    completion(nil , error)
                }
            case .failure(let error) :
                print(error.localizedDescription)
                completion(nil , error)
            }
        }
    }
    
    
    @IBAction func inProgressButtonPressed(_ sender: UIButton) {
        print(sender.center)
        self.selectionView.center.x = sender.center.x
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        
        self.orders.removeAll()
        self.tableView.reloadData()
        
        getOrders { (orders, error) in
            if let error = error {
                print("error getting orders: \(error.localizedDescription)")
            }
            if let orders = orders {
                self.orders = orders.data?.data ?? []
                self.tableView.reloadData()
            }
        }
        
    }
    @IBAction func previousButtonPressed(_ sender: UIButton) {
        print(sender.center)
        self.selectionView.center.x = sender.center.x
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        
        self.orders.removeAll()
        self.tableView.reloadData()
        
        getOldOrders { (oldOrders, error) in
            
            if let error = error {
                print("error getting old orders: \(error.localizedDescription)")
            }
            if let oldOrders = oldOrders {
                self.orders = oldOrders.data?.data ?? []
                self.tableView.reloadData()
            }
        }
        
    }
    
}


// tableview extension :
extension OrderDetailsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as OrderCell
        let order = orders[indexPath.row]
        cell.configure(order: order)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
}
