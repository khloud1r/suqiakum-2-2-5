//
//  AccountVC.swift
//  suqiakum
//
//  Created by HadyHammad on 3/12/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import UIKit

class AccountVC: BaseViewController {
    
    
    // MARK :- Instance
    static func instance () -> AccountVC {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "AccountVC") as! AccountVC
    }
    
    // MARK :- Outlets
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userPhoneLbl: UILabel!
    @IBOutlet weak var userPointsLbl: UILabel!
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    
    // MARK :- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupComponent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.userNameLbl.text = NetworkHelper.getUserName() ?? ""
        self.userPhoneLbl.text = NetworkHelper.getUserPhone() ?? ""
        self.userPointsLbl.text = "\(NetworkHelper.getUserPoints() ?? 0)"
    }
    
    func setupComponent(){
        userView.addCornerRadius(userView.frame.height / 2)
        userImageView.addCornerRadius(userImageView.frame.height / 2)
        userView.addBorderWith(width: 0.5, color: UIColor.darkGray)
    }
    
    @IBAction func buProfile(_ sender: Any) {
        if let _ =  NetworkHelper.getIsLogIn() {
            present(ProfileSettingVC.instance(), animated: true, completion: nil)
        }else{
            self.showAlertWiring(title: "يجب عليك تسجيل حساب للمتابعة")
        }
    }
    
    @IBAction func buMyPoints(_ sender: Any) {
        
    }
    
    @IBAction func buMyOrders(_ sender: Any) {
        if let _ =  NetworkHelper.getIsLogIn() {
            
        }else{
            self.showAlertWiring(title: "يجب عليك تسجيل حساب للمتابعة")
        }
    }
    
    @IBAction func buPastOrders(_ sender: Any) {
        if let _ =  NetworkHelper.getIsLogIn() {
            
        }else{
            self.showAlertWiring(title: "يجب عليك تسجيل حساب للمتابعة")
        }
    }
    
    @IBAction func buFavourite(_ sender: Any) {
        if let _ =  NetworkHelper.getIsLogIn() {
            present(WishlistVC.instance(), animated: true, completion: nil)
        }else{
            self.showAlertWiring(title: "يجب عليك تسجيل حساب للمتابعة")
        }
    }
    
    @IBAction func buSupportCenter(_ sender: Any) {
        if let _ =  NetworkHelper.getIsLogIn() {
            let nav = UINavigationController(rootViewController: SupportCenterVC.instance())
            present(nav, animated: true, completion: nil)
        }else{
            self.showAlertWiring(title: "يجب عليك تسجيل حساب للمتابعة")
        }
    }
    
    @IBAction func buUsagePolicy(_ sender: Any) {
        
    }
    
    @IBAction func buContactUs(_ sender: Any) {
        if let _ =  NetworkHelper.getIsLogIn() {
            present(ContactUsVC.instance(), animated: true, completion: nil)
        }else{
            self.showAlertWiring(title: "يجب عليك تسجيل حساب للمتابعة")
        }
    }
    
    @IBAction func buAbout(_ sender: Any) {
        present(AboutVC.instance(), animated: true, completion: nil)
    }
    
    @IBAction func buBack(_ sender: Any) {
        present(MainTabBar.instance(), animated: true, completion: nil)
    }
}
