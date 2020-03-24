//
//  ContactUsVC.swift
//  suqiakum
//
//  Created by HadyHammad on 3/13/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import UIKit

class ContactUsVC: BaseViewController {
    
    // MARK :- Instance
    static func instance () -> ContactUsVC {
        let storyboard = UIStoryboard.init(name: "Account", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
    }
    
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var phoneTxtField: UITextField!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var addressTxtField: UITextField!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageTxtView: UITextView!
    @IBOutlet weak var sendView: UIView!
    @IBOutlet weak var whatsAppView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupComponent()
    }
    
    func setupComponent(){
        messageTxtView.delegate = self
        messageTxtView.textColor = .lightGray
        sendView.addCornerRadius(8)
        whatsAppView.addCornerRadius(8)
        whatsAppView.addBorderWith(width: 1, color: UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1))
        sendView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sendTapped)))
        whatsAppView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(whatsAppTapped)))
    }
    
    @objc func whatsAppTapped() {
        
    }
    
    @objc func sendTapped() {
        if validData(){
            let param  = [ "name": nameTxtField.text ?? ""    ,
                           "phone": phoneTxtField.text ?? ""  ,
                           "title": addressTxtField.text ?? "",
                           "message": messageTxtView.text ?? ""]
            self.showLoadingIndicator()
            NetworkApi.sendRequest(method: .post, url: support, parameters: param, header: authentication, completion: { (err, status, response: SupportMessageResponse?) in
                self.hideLoadingIndicator()
                if err == nil{
                    if status!{
                        self.showAlertsuccess(title: "تم الارسال بنجاح")
                        self.finish()
                    }else{
                        self.showAlertWiring(title: "تأكد من صحة البيانات")
                    }
                }
            })
        }
    }
    
    // MARK :- Data Validations
    func validData() -> Bool{
        if messageTxtView.text!.isEmpty || messageTxtView.text == "الرسالة" {
            self.showAlertWiring(title: "يجب عليك ادخال نص الرسالة")
            return false
        }
        
        if addressTxtField.text!.isEmpty {
            self.showAlertWiring(title: "يجب عليك ادخال عنوان")
            return false
        }
        return true
    }
    
    func finish(){
        self.nameTxtField.text = nil
        self.phoneTxtField.text = nil
        self.addressTxtField.text = nil
        self.messageTxtView.text = "الرسالة"
        self.messageTxtView.textColor = .lightGray
    }
    
    @IBAction func buBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ContactUsVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "الرسالة"
            textView.textColor = .lightGray
        }
    }
}
