//
//  ResetPasswordVC.swift
//  suqiakum
//
//  Created by Hady Hammad on 3/20/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import UIKit

class ResetPasswordVC: BaseViewController {

    // MARK :- Instance
    static func instance () -> ResetPasswordVC {
        let storyboard = UIStoryboard.init(name: "Login", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "ResetPasswordVC") as! ResetPasswordVC
    }
  
    // MARK :- Outlets
    @IBOutlet weak var passwordTxtField: CustomTextField!
    @IBOutlet weak var confirmTxtField: CustomTextField!
    @IBOutlet weak var doneBtn: UIButton!
    
    // MARK :- Instance Variables
    var phone:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupComponent()
    }
    
    func setupComponent() {
        passwordTxtField.delegate = self
        confirmTxtField.delegate = self
        doneBtn.addBtnCornerRadius(8)
    }
    
    @IBAction func buDoneTapped(_ sender: Any) {
        if validData() {
            
            let param = [
                "phone" : phone!,
                "password" : passwordTxtField.text!,
                "password_confirmation" : confirmTxtField.text!
            ]
            
            self.showLoadingIndicator()
            NetworkMangerUser.instance.Resetpassword(userInfoDict: param) { (data, error) in
                self.hideLoadingIndicator()
                if data != nil {
                    if data!.status! {
                        if data!.status! {
                            self.showAlertsuccess(title: "تم تغيير كلمة السر بنجاح")
                            self.present(LoginVC.instance(), animated: true, completion: nil)
                        }
                    }else{
                        self.showAlertWiring(title: "غير قادر علي تغيير كلمة السر")
                    }
                    
                } else if error != nil {
                    self.showAlertError(title: error!.localizedDescription)
                }
            }
            
        }
    }
    
    @IBAction func Back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK :- Data Validations
    func validData() -> Bool {
        if passwordTxtField.text!.isEmpty{
            self.showAlertWiring(title: "من فضلك أدخل الرقم السري")
            return false
        }
       
        if confirmTxtField.text!.isEmpty{
            self.showAlertWiring(title: "من فضلك أدخل تأكيد الرقم السري")
            return false
        }
        
        if passwordTxtField.text != confirmTxtField.text{
            self.showAlertWiring(title: "الرقم السري غير متطابق")
            return false
        }

        return true
    }
    
}

extension ResetPasswordVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.selectedBorderColor.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.lightGray.cgColor
    }
}
