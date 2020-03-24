//
//  Confirm.swift
//  suqiakum
//
//  Created by hany karam on 3/4/20.
//  Copyright © 2020 hany karam. All rights reserved.
//

import UIKit

class ConfirmVC: BaseViewController {
    
    // MARK :- Instance
    static func instance () -> ConfirmVC {
        let storyboard = UIStoryboard.init(name: "Login", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "ConfirmVC") as! ConfirmVC
    }
    
    // MARK :- Outlets
    @IBOutlet weak var codeTxtField: UITextField!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var codeView: UIView!
    
    // MARK :- Instance Variables
    var phone : String?
    var fromForget = false
    
    // MARK :- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        codeTxtField.delegate = self
        confirmBtn.addBtnCornerRadius(8)
    }
    
    @IBAction func Back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Confirm(_ sender: Any) {
        
        if codeTxtField.text == "" {
            self.showAlertWiring(title: "من فضلك ادخل رقم التأكيد")
            return
        }
        
        if fromForget{
            forgetPassword()
        }else{
            acountActiviation()
        }
        
    }
    
    func acountActiviation() {
        
        let parm = [ "activation_token": codeTxtField.text!]
        self.showLoadingIndicator()
        NetworkMangerUser.instance.Activate(userInfoDict: parm) { (data, error) in
            self.hideLoadingIndicator()
            if data != nil {
                guard let msg = data?.message else{return}
                if data?.status == true {
                    guard let token = data?.access_token else{return}
                    self.showAlertsuccess(title: "رمز التأكيد صحيح")
                    NetworkHelper.accessToken = token
                    let completeInformationVC = CompleteInformationVC.instance()
                    completeInformationVC.phone = self.phone
                    self.present(completeInformationVC, animated: true, completion: nil)
                } else {
                    self.showAlertWiring(title: msg)
                }
            } else if let err = error {
                self.showAlertError(title: err.localizedDescription)
            }
        }
        
    }
    
    func forgetPassword() {
        let parm = [ "token": codeTxtField.text!]
        self.showLoadingIndicator()
        NetworkMangerUser.instance.ChechToken(userInfoDict: parm) { (data, error) in
            self.hideLoadingIndicator()
            if data != nil {
                guard let msg = data?.message else{return}
                if data?.status == true {
                    self.showAlertsuccess(title: "رمز التأكيد صحيح")
                    let resetPasswordVC = ResetPasswordVC.instance()
                    resetPasswordVC.phone = self.phone
                    self.present(resetPasswordVC, animated: true, completion: nil)
                } else {
                    self.showAlertWiring(title: msg)
                }
            } else if let err = error {
                self.showAlertError(title: err.localizedDescription)
            }
        }
    }
    
    @IBAction func Resend(_ sender: Any) {
        let param = [ "phone": phone! ]
        NetworkMangerUser.instance.Resend(userInfoDict: param) { (data, error) in
            if data != nil {
                if data?.status == true
                {
                    if let msg = data?.message {
                        self.showAlertsuccess(title: msg)
                    }
                    
                } else if let err = error {
                    self.showAlertError(title: err.localizedDescription)
                }
            }
        }
    }
    
}

extension ConfirmVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        codeView.backgroundColor = .selectedBorderColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        codeView.backgroundColor = .borderColor
    }
}
