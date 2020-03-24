//
//  SearchViewController.swift
//  suqiakum
//
//  Created by khloud on 3/7/20.
//  Copyright © 2020 khloud. All rights reserved.
//

import UIKit

class SearchViewController: BaseViewController, UISearchBarDelegate {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var searchResultArray = [Details]()
    typealias JSONStandard = [String : AnyObject]

    override func viewDidLoad() {
        super.viewDidLoad()
        if let textFieldInsideSearchBar  = searchBar.value(forKey: "searchField") as? UITextField{
            textFieldInsideSearchBar.font = textFieldInsideSearchBar.font?.withSize(13)
            if let textField = textFieldInsideSearchBar.subviews.first{
                textField.backgroundColor = .white
                textField.layer.cornerRadius = 6
                textField.clipsToBounds = true
            }
        }
        tableView.registerCellNib(cellClass: SearchProductCell.self)
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.textAlignment = .right
            textfield.textColor = UIColor(red: 55/255, green: 97/255, blue: 116/255, alpha: 1)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keywords = searchBar.text else { return }
        search(keyword: keywords)
        self.view.endEditing(true)
    }
    
    func search(keyword: String) {
        self.showLoadingIndicator()
        NetworkApi.sendRequest( method: .post, url: SEARCH, parameters: ["keyword": keyword], completion: { (err, status, response: DetailsResponse?) in
            self.hideLoadingIndicator()
            if err == nil{
                if status!{
                    guard let result = response?.data?.data else{return}
                    self.searchResultArray = result
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    @IBAction func back(_ sender: Any) {
        present(MainTabBar.instance(), animated: true, completion: nil)
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as SearchProductCell
        cell.addToCartBtn.tag = self.searchResultArray[indexPath.row].id!
        cell.addToCartBtn.addTarget(self, action: #selector(buAddToCartPress(_:)), for: .touchUpInside)
        cell.configure(product: searchResultArray[indexPath.row])
        return cell
    }
    
    @objc func buAddToCartPress(_ sender: UIButton){
        self.showLoadingIndicator()
        NetworkApi.sendRequest(method: .post, url: cart, parameters: ["product_id": sender.tag], header: authentication, completion: { (err,status,response: CartResponse?) in
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = ProductDetailsVC.instance()
        detailVC.product = self.searchResultArray[indexPath.row]
        self.present(detailVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}
