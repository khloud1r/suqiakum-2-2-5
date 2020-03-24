//
//  MainTabBar.swift
//  suqiakum
//
//  Created by HadyHammad on 3/12/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import UIKit

class MainTabBar: UITabBarController {
    
    // MARK :- Instance
    static func instance () -> MainTabBar {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "MainTabBar") as! MainTabBar
    }
    
    // MARK :- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = 3
    }
    
}
