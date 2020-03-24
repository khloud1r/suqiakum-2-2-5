//
//  ProfileVC.swift
//  suqiakum
//
//  Created by HadyHammad on 3/12/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import UIKit

class ProfileSettingVC: UIViewController {
    
    // MARK :- Instance
    static func instance () -> ProfileSettingVC {
        let storyboard = UIStoryboard.init(name: "Account", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "ProfileSettingVC") as! ProfileSettingVC
    }
    
    // MARK :- Instance Variables
    @IBOutlet weak var userBalanceLbl: UILabel!
    
    // MARK :- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userBalanceLbl.text = "\(NetworkHelper.getUserBalance() ?? 0)"
    }
    
    @IBAction func buProfile(_ sender: Any) {
        present(EditProfileVC.instance(), animated: true, completion: nil)
    }
    
    @IBAction func buDeliveryAddress(_ sender: Any) {
        present(DeliveryLocationVC.instance(), animated: true, completion: nil)
    }
    
    @IBAction func buNotificationSetting(_ sender: Any) {
        present(NotificationVC.instance(), animated: true, completion: nil)
    }
    
    @IBAction func buPayment(_ sender: Any) {
        
    }
    
    @IBAction func buLogOut(_ sender: Any) {
        NetworkHelper.logout()
        NetworkHelper.logoutUserIdCleanUp()
        NetworkHelper.logoutUserNameCleanUp()
        NetworkHelper.logoutUserEmailCleanUp()
        NetworkHelper.logoutUserPhoneCleanUp()
        NetworkHelper.logoutUserPointsCleanUp()
        NetworkHelper.logoutUserBalanceCleanUp()
        NetworkHelper.logoutAccessTokenCleanUp()
        UIApplication.shared.keyWindow?.rootViewController = LoginVC.instance()
    }
    
    @IBAction func buBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
