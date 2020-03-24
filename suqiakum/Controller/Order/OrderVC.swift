//
//  OrderVC.swift
//  suqiakum
//
//  Created by Hady Hammad on 3/9/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import ZDCChat

class OrderVC: BaseViewController {
    
    // MARK :- Instance
    static func instance () -> OrderVC {
        let storyboard = UIStoryboard.init(name: "Order", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "OrderVC") as! OrderVC
    }
    
    // MARK :- Outlets
    @IBOutlet weak var selectTimeView: UIView!
    @IBOutlet var timeView: UIView!
    @IBOutlet var topView: UIView!
    @IBOutlet weak var daysCV: UICollectionView!
    @IBOutlet weak var deliveryTimeTV: UITableView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var coponView: UIView!
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var phoneTxtField: UITextField!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet var descountView: UIView!
    @IBOutlet weak var descountTxtField: UITextField!
    @IBOutlet weak var cancelDescountBtn: UIButton!
    @IBOutlet weak var confirmDescountBtn: UIButton!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var infoTxtView: UITextView!
    @IBOutlet weak var contactUsView: UIView!
    @IBOutlet weak var callCenterView: UIView!
    @IBOutlet weak var orderPriceLbl: UILabel!
    @IBOutlet weak var additionalValueLbl: UILabel!
    @IBOutlet weak var deliveryCostLbl: UILabel!
    @IBOutlet weak var descountLbl: UILabel!
    @IBOutlet weak var totalDescountLbl: UILabel!
    @IBOutlet weak var totalOrderPriceLbl: UILabel!
    @IBOutlet weak var sendOrderBtn: UIButton!
    @IBOutlet weak var descountPercentLbl: UILabel!
    @IBOutlet weak var addressTV: UITableView!
    @IBOutlet weak var addressViewHight: NSLayoutConstraint!
    @IBOutlet weak var timeSelectedLbl: UILabel!
    //Pay
    @IBOutlet weak var visaPayView: UIView!
    @IBOutlet weak var applePayView: UIView!
    @IBOutlet weak var madaPayView: UIView!
    @IBOutlet weak var cashPayView: UIView!
    
    // MARK :- Instance Variables
    var companyID: Int?
    var deliveryDate:String?
    var deliveryTime:Int?
    var deliveryTimeText = ""
    var coponCode:String?
    var paymentMethod = ""
    var addressArray:[Address] = []
    var daysArray:[Day] = []
    var timeArray:[Time] = []
    var selectedIndex:IndexPath?
    var daysSelectedIndex:IndexPath = IndexPath(row: 0, section: 0)
    var timeSelectedIndex:IndexPath?
    var addressID: Int?
    var order:Order?
    
    // MARK :- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupComponent()
        loadLocations()
        getTotalPrice(copoun: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func setupComponent(){
        daysCV.registerCellNib(cellClass: DayCVC.self)
        deliveryTimeTV.registerCellNib(cellClass: DeliveryTimeTVC.self)
        timeView.addCornerRadius(8)
        descountView.addCornerRadius(8)
        sendOrderBtn.addCornerRadius(8)
        //Pay
        visaPayView.addCornerRadius(8)
        applePayView.addCornerRadius(8)
        madaPayView.addCornerRadius(8)
        cashPayView.addCornerRadius(8)
        visaPayView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(visaPayTapped)))
        applePayView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(applePayTapped)))
        madaPayView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(madaPayTapped)))
        cashPayView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cashPayTapped)))
        
        callCenterView.addCornerRadius(8)
        callCenterView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(callTapped)))
        contactUsView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chatTapped)))
        
        contactUsView.addCornerRadius(8)
        contactUsView.addBorderWith(width: 1, color: UIColor(red: 36/255, green: 99/255, blue: 255/255, alpha: 1))
        
        selectTimeView.addCornerRadius(8)
        selectTimeView.addBorderWith(width: 1, color: UIColor(red: 36/255, green: 99/255, blue: 255/255, alpha: 1))
        selectTimeView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectTimeTapped)))
        
        coponView.addCornerRadius(8)
        coponView.addBorderWith(width: 1, color: UIColor(red: 36/255, green: 99/255, blue: 255/255, alpha: 1))
        coponView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(coponTapped)))
        
        confirmBtn.addCornerRadius(17)
        cancelBtn.addCornerRadius(17)
        
        descountTxtField.addCornerRadius(8)
        confirmDescountBtn.addCornerRadius(17)
        cancelDescountBtn.addCornerRadius(17)
        infoView.addBorderWith(width: 0.5, color: UIColor.lightGray)
        infoTxtView.textColor = .lightGray
        infoTxtView.delegate = self
        nameTxtField.delegate = self
        phoneTxtField.delegate = self
        
        self.nameTxtField.text = NetworkHelper.getUserName() ?? ""
        self.phoneTxtField.text = NetworkHelper.getUserPhone() ?? ""
    }
    
    func loadLocations() {
        self.showLoadingIndicator()
        NetworkApi.sendRequest( method: .get, url: getAddress, header: authentication, completion: { (err,status,response: AddressResponse?) in
            self.hideLoadingIndicator()
            if err == nil{
                if status!{
                    if let addresses = response?.data{
                        for address in addresses{
                            if address.is_default == 1{
                                self.addressID = address.id
                            }
                        }
                        self.addressArray = addresses
                        let cellHieght = Int(self.view.frame.height * 0.13)
                        self.addressViewHight.constant = CGFloat(addresses.count * cellHieght) + 55
                        self.addressTV.reloadData()
                    }
                }
            }
        })
    }
    
    func loadAvailableTimes() {
        self.showLoadingIndicator()
        let param = ["address_id": self.addressID!]
        NetworkApi.sendRequest( method: .post, url: AVAILABLE_TIMES, parameters: param, header: authentication, completion: { (err,status,response: TimeResponse?) in
            self.hideLoadingIndicator()
            if err == nil{
                guard let msg = response?.message else{return}
                if status!{
                    if let days = response?.data{
                        self.Show_Time_View()
                        self.timeArray = days[0].times!
                        self.deliveryDate = days[0].date!
                        self.daysArray = days
                        self.daysCV.reloadData()
                    }
                }else{
                    self.showAlertWiring(title: msg)
                }
            }
        })
    }
    
    func getTotalPrice(copoun: String){
        NetworkApi.getTotalPrice(copoun: copoun, completion: { (err,status,dict) in
            if err == nil{
                if status!{
                    guard let dict = dict else{return}
                    guard let orderPrice = dict["سعر المنتجات"],
                        let additionalValue  =  dict["القيمة المضافة"],
                        let deliveryCost     = dict["سعر التوصيل"],
                        let descount         = dict["خصم الكوبون"],
                        let totalDescount    = dict["اجمالي الخصم"],
                        let totalOrderPrice  = dict["اجمالي السعر"] else{return}
                    
                    DispatchQueue.main.async {
                        self.orderPriceLbl.text = "\(Float(orderPrice)) ر.س"
                        self.additionalValueLbl.text = "\(Float(additionalValue)) ر.س"
                        self.deliveryCostLbl.text = "\(Float(deliveryCost)) ر.س"
                        self.descountLbl.text = "\(Float(descount)) ر.س"
                        self.totalDescountLbl.text = "\(Float(totalDescount)) ر.س"
                        self.totalOrderPriceLbl.text = "\(Float(totalOrderPrice)) ر.س"
                    }
                }
            }
        })
    }
    
    @objc func callTapped() {
        print("Calling 595912875 Now...")
        guard let url = URL(string: "telprompt://\(595912875)") else {return}
        UIApplication.shared.open(url)
    }
    
    @objc func chatTapped() {
        ZDCChat.start(in: self.navigationController, withConfig: nil)
    }
    
    @objc func selectTimeTapped() {
        if let _ = self.addressID {
            self.loadAvailableTimes()
        }else{
            self.showAlertWiring(title: "يجب عليك أختيار عنوان توصيل اولا")
        }
    }
    
    @objc func coponTapped() {
        Show_Descount_View()
    }
    
    //Pay Actions
    @objc func visaPayTapped() {
        self.paymentMethod = "visa"
        visaPayView.addBorderWith(width: 1, color: UIColor(red: 36/255, green: 99/255, blue: 255/255, alpha: 1))
        applePayView.addBorderWith(width: 1, color: .white)
        madaPayView.addBorderWith(width: 1, color: .white)
        cashPayView.addBorderWith(width: 1, color: .white)
    }
    
    @objc func applePayTapped() {
        self.paymentMethod = "apple_pay"
        applePayView.addBorderWith(width: 1, color: UIColor(red: 36/255, green: 99/255, blue: 255/255, alpha: 1))
        visaPayView.addBorderWith(width: 1, color: .white)
        madaPayView.addBorderWith(width: 1, color: .white)
        cashPayView.addBorderWith(width: 1, color: .white)
    }
    
    @objc func madaPayTapped() {
        self.paymentMethod = "mada"
        madaPayView.addBorderWith(width: 1, color: UIColor(red: 36/255, green: 99/255, blue: 255/255, alpha: 1))
        visaPayView.addBorderWith(width: 1, color: .white)
        applePayView.addBorderWith(width: 1, color: .white)
        cashPayView.addBorderWith(width: 1, color: .white)
    }
    
    @objc func cashPayTapped() {
        self.paymentMethod = "cash"
        cashPayView.addBorderWith(width: 1, color: UIColor(red: 36/255, green: 99/255, blue: 255/255, alpha: 1))
        visaPayView.addBorderWith(width: 1, color: .white)
        applePayView.addBorderWith(width: 1, color: .white)
        madaPayView.addBorderWith(width: 1, color: .white)
    }
    
    func Hide_Time_View()
    {
        UIView.animate(withDuration: 0.3) {
            self.timeView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.timeView.alpha = 0
            self.timeView.removeFromSuperview()
        }
    }
    
    func Show_Time_View(){
        self.view.addSubview(timeView)
        timeView.translatesAutoresizingMaskIntoConstraints = false
        timeView.topAnchor.constraint(equalTo: self.topView.bottomAnchor, constant: 80).isActive = true
        timeView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        timeView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.75).isActive = true
        timeView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.97).isActive = true
        timeView.transform = CGAffineTransform.init(scaleX:  1.3, y: 1.3)
        timeView.alpha = 0
        UIView.animate(withDuration: 0.5){
            self.timeView.alpha = 1
            self.timeView.transform = CGAffineTransform.identity
        }
    }
    
    func Hide_Descount_View()
    {
        UIView.animate(withDuration: 0.3) {
            self.descountView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.descountView.alpha = 0
            self.descountView.removeFromSuperview()
        }
    }
    
    func Show_Descount_View(){
        self.view.addSubview(descountView)
        descountView.translatesAutoresizingMaskIntoConstraints = false
        descountView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        descountView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        descountView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        descountView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9).isActive = true
        descountView.transform = CGAffineTransform.init(scaleX:  1.3, y: 1.3)
        descountView.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.descountView.alpha = 1
            self.descountView.transform = CGAffineTransform.identity
        }
    }
    
    @IBAction func buConfirm(_ sender: Any) {
        if let _ = self.deliveryTime{
            let date = self.deliveryDate ?? ""
            self.timeSelectedLbl.text = date + " - " + self.deliveryTimeText
            Hide_Time_View()
        }else{
            self.showAlertWiring(title: "يجب عليك اختيار وقت التوصيل المناسب لك")
        }
    }
    
    @IBAction func buCancel(_ sender: Any) {
        Hide_Time_View()
    }
    
    @IBAction func buConfirmDescount(_ sender: Any) {
        if let copoun = descountTxtField.text{
            NetworkApi.sendRequest(method: .post, url: COPOUN_URL, parameters: ["copoun_code": copoun], header: authentication, completion: { (err,status,response: CopounResponse?) in
                if err == nil{
                    guard let message = response?.message else{return}
                    if status!{
                        if message == "تم اضافة الكوبون بنجاح!" {
                            guard let descount = response?.data?.max_amount else{return}
                            print(descount)
                            self.descountPercentLbl.text = "\(descount)%"
                            self.coponCode = copoun
                            self.getTotalPrice(copoun: copoun)
                            self.descountTxtField.text = nil
                            self.showAlertsuccess(title: message)
                        }
                    }
                }else{
                    self.showAlertWiring(title: "كوبون خاطئ")
                }
            })
        }
    }
    
    @IBAction func buCancelDescount(_ sender: Any) {
        Hide_Descount_View()
    }
    
    @IBAction func buSendOrder(_ sender: Any) {
        if validData() {
            let parameter : [String:Any] = ["address_id": self.addressID!,
                                            "copoun_code": coponCode ?? "",
                                            "delivery_date": self.deliveryDate!,
                                            "delivery_time": self.deliveryTime!,
                                            "payment_method": self.paymentMethod,
                                            "recipient_name": self.nameTxtField.text!,
                                            "recipient_phone": self.phoneTxtField.text!,
                                            "user_notes": self.infoTxtView.text ?? "",
                                            "platform": "ios"]
            
            self.showLoadingIndicator()
            NetworkApi.sendRequest(method: .post, url: ORDER_URL, parameters: parameter, header: authentication, completion: { (err, status, response: OrderResponse?) in
                self.hideLoadingIndicator()
                if err == nil {
                    guard let msg = response?.message else{return}
                    if status!{
                        self.order = response?.data
                        self.showAlertsuccess(title: msg)
                    }else{
                        self.showAlertWiring(title: msg)
                    }
                }else{
                    self.showAlertError(title: "غير قادر علي اتمام الطلب")
                }
            })
        }
    }
    
    // MARK :- Data Validations
    func validData() -> Bool{
        
        if self.addressID == nil {
            self.showAlertWiring(title: "يجب عليك أختيار عنوان للتوصيل")
            return false
        }
        
        if self.deliveryTime == nil {
            self.showAlertWiring(title: "يجب عليك أختيار ميعاد التوصيل")
            return false
        }
        
        if self.deliveryDate == nil {
            self.showAlertWiring(title: "يجب عليك أختيار يوم التوصيل")
            return false
        }
        
        if self.paymentMethod == "" {
            self.showAlertWiring(title: "يجب عليك أختيار وسيلة للدفع")
            return false
        }
        
        if nameTxtField.text!.isEmpty{
            self.showAlertWiring(title: "يجب عليك أدخال اسم المستخدم")
            return false
        }
        
        if phoneTxtField.text!.isEmpty{
            self.showAlertWiring(title: "يجب عليك أدخال رقم الهاتف")
            return false
        }
        
        return true
    }
    
    func finish() {
        self.phoneTxtField.text = ""
        self.nameTxtField.text  = ""
        self.paymentMethod = ""
        self.deliveryDate = ""
        self.deliveryTimeText = ""
        self.deliveryTime = nil
        self.nameTxtField.text = NetworkHelper.getUserName() ?? ""
        self.phoneTxtField.text = NetworkHelper.getUserPhone() ?? ""
        self.timeSelectedLbl.text = "اليوم - ميعاد التوصيل"
    }
    
    @IBAction func buBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension OrderVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return daysArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(indexPath: indexPath) as DayCVC
        if indexPath == daysSelectedIndex {
            cell.dateLbl.textColor = .selectedBorderColor
            cell.dayNameLbl.textColor = .selectedBorderColor
        }else{
            cell.dateLbl.textColor = .borderColor
            cell.dayNameLbl.textColor = .borderColor
        }
        cell.configure(day: self.daysArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width-40) / 4, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        daysSelectedIndex = indexPath
        self.timeArray = self.daysArray[indexPath.row].times!
        self.deliveryDate = self.daysArray[indexPath.row].date
        self.deliveryTimeTV.reloadData()
        self.daysCV.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension OrderVC: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == addressTV{
            return addressArray.count
        }else{
            return timeArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == addressTV{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddressTVC", for: indexPath) as! AddressTVC
            cell.configure(address: self.addressArray[indexPath.row])
            return cell
        }else{
            let cell = deliveryTimeTV.dequeue() as DeliveryTimeTVC
            setupDeliveryTimeCell(cell: cell, indexPath: indexPath)
            cell.configure(time: self.timeArray[indexPath.row])
            return cell
        }
    }
    
    func setupDeliveryTimeCell(cell: DeliveryTimeTVC, indexPath: IndexPath) {
        if indexPath == timeSelectedIndex{
            cell.deliveryTimeLbl.textColor = UIColor(red: 36/255, green: 99/255, blue: 255/255, alpha: 1)
        }else{
            cell.deliveryTimeLbl.textColor = UIColor(red: 146/255, green: 146/255, blue: 146/255, alpha: 1)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == addressTV{
            
            guard let addressID = self.addressArray[indexPath.row].id else{return}
            self.showLoadingIndicator()
            NetworkApi.sendRequest(method: .post, url: MAKE_DEFAULT, parameters: ["address_id": addressID], header: authentication, completion: { (err,status,response: AddressAddedResponse?) in
                self.hideLoadingIndicator()
                if err == nil {
                    guard let msg = response?.message else{return}
                    if status!{
                        self.showAlertsuccess(title: msg)
                        self.loadLocations()
                    }else{
                        self.showAlertWiring(title: msg)
                    }
                }
            })
            
        }else{
            self.deliveryTime = self.timeArray[indexPath.row].id
            self.deliveryTimeText = self.timeArray[indexPath.row].time ?? ""
            timeSelectedIndex = indexPath
            self.deliveryTimeTV.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == addressTV{
            return self.view.frame.height * 0.13
        }else{
            return 40
        }
    }
}

extension OrderVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == nameTxtField{
            nameView.backgroundColor  = .selectedBorderColor
        }else{
            phoneView.backgroundColor = .selectedBorderColor
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == nameTxtField{
            nameView.backgroundColor = .borderColor
        }else{
            phoneView.backgroundColor = .borderColor
        }
    }
}

extension OrderVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "مثال لا تدق الجرس لانه لا يعمل"
            textView.textColor = .lightGray
        }
    }
}
