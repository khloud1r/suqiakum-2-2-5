//
//  SigInViewController.swift
//  suqiakum
//
//  Created by hany karam on 3/2/20.
//  Copyright © 2020 hany karam. All rights reserved.
//

import UIKit

class LoginVC: BaseViewController {
    
    // MARK :- Instance
    static func instance () -> LoginVC {
        let storyboard = UIStoryboard.init(name: "Login", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
    }
    
    // MARK :- Outlets
    @IBOutlet weak var phoneTxtField: CustomTextField!
    @IBOutlet weak var passwordTxtField: CustomTextField!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var showHomeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupComponent()
    }
    
    func setupComponent() {
        phoneTxtField.delegate = self
        passwordTxtField.delegate = self
        loginBtn.addBtnCornerRadius(8)
        registerBtn.addBtnCornerRadius(20)
        showHomeBtn.addBtnCornerRadius(8)
        registerBtn.addBtnBorderWith(width: 1, color: .selectedBorderColor)
        showHomeBtn.addBtnBorderWith(width: 1, color: .selectedBorderColor)
    }
    
    @IBAction func buRegister(_ sender: Any) {
        self.present(RegisterVC.instance(), animated: true, completion: nil)
    }
    
    @IBAction func buShowHome(_ sender: Any) {
        self.present(MainTabBar.instance(), animated: true, completion: nil)
    }
    
    @IBAction func buLogin(_ sender: Any) {
        if validData(){
            let parm = [
                "phone": phoneTxtField.text ?? "",
                "password": passwordTxtField.text ?? "",
            ]
            
            self.showLoadingIndicator()
            NetworkMangerUser.instance.loginUser(userInfoDict: parm) { [unowned self] (user, error) in
                self.hideLoadingIndicator()
                if error  == nil{
                    DispatchQueue.main.async {
                        guard let status = user?.status else{return}
                        if status{
                            NetworkHelper.isLogIn = true
                            NetworkHelper.userName = user?.data?.name
                            NetworkHelper.userID = user?.data?.id
                            NetworkHelper.userPoint = user?.data?.totalPoints
                            NetworkHelper.userBalance = user?.data?.totalBalance
                            NetworkHelper.userPhone = user?.data?.phone
                            NetworkHelper.accessToken = user?.accessToken
                            NetworkHelper.userEmail = user?.data?.email
                            UserDefaults.standard.synchronize()
                            self.showAlertsuccess(title: "تم تسجيل الدخول بنجاح")
                            self.finish()
                            self.present(MainTabBar.instance(), animated: true, completion: nil)
                        }else{
                            self.showAlertWiring(title: "خطأ في التسجيل اعد كتابة رقم الهاتف او كلمة المرور")
                        }
                    }
                }else{
                    self.showAlertWiring(title: "خطأ في التسجيل اعد كتابة رقم الهاتف او كلمة المرور")
                }
            }
        }
    }
    
    @IBAction func buForgetPassword(_ sender: Any) {
        self.present(ForgetPasswordVC.instance(), animated: true, completion: nil)
    }
    
    // MARK :- Data Validations
    func validData() -> Bool{
        
        if phoneTxtField.text!.isEmpty && passwordTxtField.text!.isEmpty{
            self.showAlertWiring(title: "من فضلك ادخل البيانات")
            return false
        }
        
        if phoneTxtField.text!.isEmpty{
            self.showAlertWiring(title: "ادخل رقم الهاتف")
            return false
        }
        
        if passwordTxtField.text!.isEmpty{
            self.showAlertWiring(title: "ادخل كلمة المرور")
            return false
        }
        
        return true
    }
    
    func finish(){
        self.phoneTxtField.text = ""
        self.passwordTxtField.text = ""
    }
    
}

extension LoginVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.selectedBorderColor.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.lightGray.cgColor
    }
}



