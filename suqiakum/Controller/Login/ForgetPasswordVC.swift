//
//  ForgetPasswordVC.swift
//  suqiakum
//
//  Created by Hady Hammad on 3/20/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import UIKit

class ForgetPasswordVC: BaseViewController {

    // MARK :- Instance
    static func instance () -> ForgetPasswordVC {
        let storyboard = UIStoryboard.init(name: "Login", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "ForgetPasswordVC") as! ForgetPasswordVC
    }
    
    // MARK :- Outlets
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var phoneTxtField: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneTxtField.delegate = self
        nextBtn.addBtnCornerRadius(8)
    }
    
    @IBAction func buNextTapped(_ sender: Any) {
        
        if phoneTxtField.text!.isEmpty{
            self.showAlertWiring(title: "الرجاء ملئ رقم الهاتف")
            return
        }
        
        let param = [
            "phone" : phoneTxtField.text!
        ]

        self.showLoadingIndicator()
        NetworkApi.sendRequest(method: .post, url: FORGET_PASSWORD, parameters: param, completion: { (err,status,response: ForgertResponse?) in
            self.hideLoadingIndicator()
            if err == nil{
                guard let msg = response?.message else{return}
                if status!{
                    self.showAlertsuccess(title: "تم أرسال رمز التأكيد بنجاح")
                    self.phoneTxtField.text = ""
                    guard let phone = response?.data?.phone else{return}
                    let confirmVC = ConfirmVC.instance()
                    confirmVC.fromForget = true
                    confirmVC.phone = phone
                    self.present(confirmVC, animated: true, completion: nil)
                }else{
                    self.showAlertWiring(title: msg)
                }
            }
        })
    }
    
    @IBAction func Back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension ForgetPasswordVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
       phoneView.backgroundColor = .selectedBorderColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
       phoneView.backgroundColor = .borderColor
    }
}
