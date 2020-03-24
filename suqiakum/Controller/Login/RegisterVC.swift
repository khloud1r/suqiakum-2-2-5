//
//  RegisterViewController.swift
//  suqiakum
//
//  Created by hany karam on 3/3/20.
//  Copyright © 2020 hany karam. All rights reserved.
//

import UIKit


import UIKit


class RegisterVC: BaseViewController {
    
    // MARK :- Instance
    static func instance () -> RegisterVC {
        let storyboard = UIStoryboard.init(name: "Login", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
    }
    
    // MARK :- Outlets
    @IBOutlet var userInfoTxts: [UITextField]!
    @IBOutlet weak var passwordStrengthLabel: UILabel!
    @IBOutlet weak var RegisterBtn: UIButton!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var confirmView: UIView!
    @IBOutlet weak var phoneView: UIView!
    
    var passwordEqual:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupComponent()
    }
    
    func setupComponent(){
        RegisterBtn.addCornerRadius(8)
        userInfoTxts[0].delegate = self
        userInfoTxts[1].delegate  = self
        userInfoTxts[2].delegate = self
    }
    
    @IBAction func buRegisterTapped(_ sender: Any) {
        if validData() {
            let param = [
                "phone" :userInfoTxts[0].text!,
                "password": userInfoTxts[1].text!,
                "password_confirmation" : userInfoTxts[2].text!
            ]
            
            self.showLoadingIndicator()
            NetworkMangerUser.instance.registerNewUser(userInfoDict: param) { (user, error) in
                self.hideLoadingIndicator()
                if user != nil {
                    if user!.status! {
                        if user!.status! {
                            self.showAlertsuccess(title: "تم أرسال رمز التأكيد بنجاح")
                            self.present(ConfirmVC.instance(), animated: true, completion: nil)
                        }
                    }else{
                        self.showAlertWiring(title: user?.message ?? "")
                    }
                    
                } else if error != nil {
                    self.showAlertError(title: error!.localizedDescription)
                }
            }
        }
    }
    
    // MARK :- Data Validations
    func validData() -> Bool{
        
        if userInfoTxts[0].text!.isEmpty && userInfoTxts[1].text!.isEmpty && userInfoTxts[2].text!.isEmpty{
            self.showAlertWiring(title: "الرجاء ملئ جميع الحقول")
            return false
        }
        
        if userInfoTxts[0].text!.isEmpty{
            self.showAlertWiring(title: "ادخل رقم الهاتف")
            return false
        }
        
        if userInfoTxts[1].text!.isEmpty{
            self.showAlertWiring(title: "ادخل كلمة المرور")
            return false
        }
        
        if userInfoTxts[1].text!.count < 6{
            self.showAlertWiring(title: "كلمة المرور يجب ألا تقل عن ستة احرف")
            return false
        }
        
        if userInfoTxts[2].text!.isEmpty{
            self.showAlertWiring(title: "ادخل تأكيد كلمة المرور")
            return false
        }
        
        if userInfoTxts[1].text! != userInfoTxts[2].text!{
            self.showAlertWiring(title: "كلمة المرور غير متطابقة")
            return false
        }
        
        return true
    }
    
    func finish(){
        self.userInfoTxts[0].text = ""
        self.userInfoTxts[1].text = ""
        self.userInfoTxts[2].text = ""
    }
    
    @IBAction func Back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension RegisterVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == userInfoTxts[1]{
            passwordView.backgroundColor  = .selectedBorderColor
        }else if textField == userInfoTxts[2]{
            confirmView.backgroundColor = .selectedBorderColor
        }else{
            phoneView.backgroundColor = .selectedBorderColor
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == userInfoTxts[1]{
            passwordView.backgroundColor = .borderColor
        }else if textField == userInfoTxts[2]{
            confirmView.backgroundColor = .borderColor
        }else{
            phoneView.backgroundColor = .borderColor
        }
    }
}
