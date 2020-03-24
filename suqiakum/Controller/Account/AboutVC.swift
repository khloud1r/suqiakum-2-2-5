//
//  AboutVC.swift
//  suqiakum
//
//  Created by HadyHammad on 3/13/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import UIKit

class AboutVC: UIViewController {
    
    // MARK :- Instance
    static func instance () -> AboutVC {
        let storyboard = UIStoryboard.init(name: "Account", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "AboutVC") as! AboutVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func buBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
