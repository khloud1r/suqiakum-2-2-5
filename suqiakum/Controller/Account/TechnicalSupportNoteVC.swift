//
//  TechnicalSupportNoteVC.swift
//  suqiakum
//
//  Created by HadyHammad on 3/13/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import UIKit

class TechnicalSupportNoteVC: BaseViewController {
    
    // MARK :- Instance
    static func instance () -> TechnicalSupportNoteVC {
        let storyboard = UIStoryboard.init(name: "Account", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "TechnicalSupportNoteVC") as! TechnicalSupportNoteVC
    }
    
    // MARK :- Outlets
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleTxtField: UITextField!
    @IBOutlet weak var orderView: UIView!
    @IBOutlet weak var orderTxtField: UITextField!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageTxtView: UITextView!
    @IBOutlet weak var sendBtn: UIButton!
    
    // MARK :- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTxtView.delegate = self
        messageTxtView.textColor = .lightGray
    }
    
    @IBAction func buSend(_ sender: Any) {
        if validData() {
            self.showAlertsuccess(title: "تم الارسال بنجاح")
        }
    }
    
    @IBAction func buBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK :- Data Validations
    func validData() -> Bool{
        if messageTxtView.text!.isEmpty || messageTxtView.text == "الرسالة" {
            self.showAlertWiring(title: "يجب عليك ادخال نص الرسالة")
            return false
        }
        
        if titleTxtField.text!.isEmpty {
            self.showAlertWiring(title: "يجب عليك ادخال الموضوع")
            return false
        }
        
        if orderTxtField.text!.isEmpty {
            self.showAlertWiring(title: "يجب عليك ادخال نص الطلب")
            return false
        }
        
        return true
    }
    
    func finish(){
        self.titleTxtField.text = nil
        self.orderTxtField.text = nil
        self.messageTxtView.text = "أكتب رسالتك هنا بالتفصيل"
        self.messageTxtView.textColor = .lightGray
    }
}

extension TechnicalSupportNoteVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "أكتب رسالتك هنا بالتفصيل"
            textView.textColor = .lightGray
        }
    }
}
