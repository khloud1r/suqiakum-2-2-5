//
//  pointViewController.swift
//  suqiakum
//
//  Created by Hany Karam on 3/24/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import UIKit

class pointViewController: UIViewController {

    @IBOutlet weak var point: UILabel!
    @IBOutlet weak var userPointtsLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.userPointtsLbl.text = "\(NetworkHelper.getUserPoints() ?? 0)"
        
        
        self.point.text = "\(NetworkHelper.getUserPoints() ?? 0)"

    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
