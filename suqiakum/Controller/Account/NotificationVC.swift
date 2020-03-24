//
//  NotificationVC.swift
//  suqiakum
//
//  Created by HadyHammad on 3/12/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import UIKit

class NotificationVC: UIViewController {

    // MARK :- Instance
    static func instance () -> NotificationVC {
        let storyboard = UIStoryboard.init(name: "Account", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func buBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
