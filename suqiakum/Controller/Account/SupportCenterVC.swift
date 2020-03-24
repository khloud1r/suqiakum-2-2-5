//
//  SupportCenterVC.swift
//  suqiakum
//
//  Created by HadyHammad on 3/13/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import ZDCChat

class SupportCenterVC: UIViewController {

    // MARK :- Instance
    static func instance () -> SupportCenterVC {
        let storyboard = UIStoryboard.init(name: "Account", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "SupportCenterVC") as! SupportCenterVC
    }
    
    // MARK :- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func buChat(_ sender: Any) {
        ZDCChat.start(in: self.navigationController, withConfig: nil)
    }
    
    @IBAction func buCallUs(_ sender: Any) {
        
    }
    
    @IBAction func buTechnicalSupport(_ sender: Any) {
        present(TechnicalSupportNoteVC.instance(), animated: true, completion: nil)
    }
    
    @IBAction func buCommonQuestions(_ sender: Any) {
        
    }
    
    @IBAction func buBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
