//
//  EditProfileVC.swift
//  suqiakum
//
//  Created by HadyHammad on 3/12/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import UIKit

class EditProfileVC: BaseViewController {
    
    // MARK :- Instance
    static func instance () -> EditProfileVC {
        let storyboard = UIStoryboard.init(name: "Account", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
    }
    
    // MARK :- Outlets
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var phoneTxtField: UITextField!
    @IBOutlet weak var editDoneBtn: UIButton!
    
    // MARK :- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupComponent()
    }
    
    func setupComponent(){
        userView.addCornerRadius(userView.frame.height / 2)
        userImageView.addCornerRadius(userImageView.frame.height / 2)
        userView.addBorderWith(width: 0.5, color: UIColor.darkGray)
        editDoneBtn.addCornerRadius(8)
        editDoneBtn.addBorderWith(width: 1, color: .selectedBorderColor)
        nameTxtField.delegate  = self
        emailTxtField.delegate = self
        phoneTxtField.delegate = self
        loadUserProfile()
    }
    
    func loadUserProfile() {
        self.showLoadingIndicator()
        NetworkApi.sendRequest(method: .get, url: Profile, header: authentication, completion: { (err, status, response: UserResponse?) in
            self.hideLoadingIndicator()
            if err == nil{
                if status!{
                    if let user = response?.data{
                        DispatchQueue.main.async {
                            self.nameTxtField.text = user.name
                            self.emailTxtField.text = user.email
                            self.phoneTxtField.text = user.phone
                        }
                    }
                }else{
                    self.showAlertWiring(title: "غير قادر علي تحميل بيانات الملف الشخصي")
                }
            }else{
                self.showAlertWiring(title: "غير قادر علي تحميل بيانات الملف الشخصي")
            }
        })
    }
    
    @IBAction func buDone(_ sender: Any) {
        let param = ["name": nameTxtField.text ?? "", "email": emailTxtField.text ?? "", "phone": phoneTxtField.text ?? ""]
        self.showLoadingIndicator()
        NetworkApi.sendRequest(method: .post, url: updateProfile, parameters: param, header: authentication, completion: { (err,status,response: UserResponse?) in
            self.hideLoadingIndicator()
            if err == nil{
                if status!{
                    self.showAlertsuccess(title: "تم نحديث البيانات بنجاح")
                    guard let name  = response?.data?.name,
                        let phone   = response?.data?.phone,
                        let email   = response?.data?.email else{return}
                    
                    NetworkHelper.userName = name
                    NetworkHelper.userPhone = phone
                    NetworkHelper.userEmail = email
                    UserDefaults.standard.synchronize()
                }else{
                    self.showAlertWiring(title: "غير قادر علي التحديث")
                }
            }else{
                self.showAlertError(title: "غير قادر علي التحديث")
            }
        })
    }
    
    @IBAction func buBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension EditProfileVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor = .black
        if textField == nameTxtField{
            nameView.backgroundColor  = .selectedBorderColor
        }else if textField == emailTxtField{
            emailView.backgroundColor = .selectedBorderColor
        }else{
            phoneView.backgroundColor = .selectedBorderColor
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == nameTxtField{
            nameView.backgroundColor = .borderColor
        }else if textField == emailTxtField{
            emailView.backgroundColor = .borderColor
        }else{
            phoneView.backgroundColor = .borderColor
        }
    }
}
