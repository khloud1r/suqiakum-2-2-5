//
//  CompeletInformationViewController.swift
//  suqiakum
//
//  Created by hany karam on 3/3/20.
//  Copyright © 2020 hany karam. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class CompleteInformationVC: BaseViewController {
    
    // MARK :- Instance
    static func instance () -> CompleteInformationVC {
        let storyboard = UIStoryboard.init(name: "Login", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "CompleteInformationVC") as! CompleteInformationVC
    }
    
    // MARK :- Outlets
    @IBOutlet weak var addressTF: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var done: UIButton!
    @IBOutlet weak var location: UISearchBar!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var emailView: UIView!
    
    // MARK :- Instance Variables
    var phone:String?
    var locationManager  = CLLocationManager()
    let regionInMeters : Double = 500
    var user_lat  : Double = 0
    var user_lon : Double = 0
    var previousLocation  : CLLocation?
    var fullAddress = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupComponent()
    }
    
    func setupComponent() {
        name.delegate = self
        email.delegate = self
        done.addBtnCornerRadius(8)
        checkLocationServices()
        if let lat = self.locationManager.location?.coordinate.latitude, let lon = self.locationManager.location?.coordinate.longitude {
            self.user_lat  = lat
            self.user_lon = lon
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate{
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        }else{
            
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus(){
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .denied:
            break
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            startTrackingUserLocation()
        @unknown default:
            print("error")
        }
    }
    
    func startTrackingUserLocation() {
        mapView.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
        previousLocation = getCenterLocation(for: mapView)
    }
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let lat = mapView.centerCoordinate.latitude
        let lon = mapView.centerCoordinate.longitude
        return CLLocation(latitude: lat, longitude: lon)
    }
    
    
    @IBAction func doneregister(_ sender: Any) {
        if validData() {
            let param = [
                "name" : name.text!,
                "email": email.text!,
                "lat"  : user_lat,
                "lng"  : user_lon ] as [String : Any]
            
            self.showLoadingIndicator()
            NetworkApi.sendRequest( method: .post, url: COMPLETE_PROFILE, parameters: param, header: authentication, completion: { (err, status, response: SignInModel?) in
                self.hideLoadingIndicator()
                if err == nil{
                    guard let msg = response?.message else{return}
                    if status!{
                        self.showAlertsuccess(title: "تم تسجيل حساب بنجاح")
                        guard let user = response?.data else{return}
                        NetworkHelper.isLogIn = true
                        NetworkHelper.userName = user.name
                        NetworkHelper.userID = user.id
                        NetworkHelper.userPoint = user.totalPoints
                        NetworkHelper.userBalance = user.totalBalance
                        NetworkHelper.userPhone = user.phone
                        NetworkHelper.userEmail = user.email
                        UserDefaults.standard.synchronize()
                        self.finish()
                        self.present(MainTabBar.instance(), animated: true, completion: nil)
                    }else{
                        self.showAlertWiring(title: msg)
                    }
                }
            })
        }
    }
    
    // MARK :- Data Validations
    func validData() -> Bool{
        if user_lat == 0.0 || user_lon == 0.0 {
            self.showAlertWiring(title: "من فضلك أختر عنوانك")
            return false
        }
        
        if name.text!.isEmpty{
            self.showAlertWiring(title: "يجب عليك أدخال اسم المستخدم")
            return false
        }
        
        if email.text!.isEmpty{
            self.showAlertWiring(title: "يجب عليك أدخال البريد الألكتروني")
            return false
        }
        
        return true
    }
    
    func finish(){
        self.name.text = ""
        self.email.text = ""
        user_lon = 0.0
        user_lat = 0.0
    }
    
    @IBAction func Back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension CompleteInformationVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

extension CompleteInformationVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//        self.addressTF.text = ""
        self.fullAddress = ""
        let center = getCenterLocation(for: mapView)
        let geoCoder = CLGeocoder()
        
        guard let previousLocation = self.previousLocation else { return }
        guard center.distance(from: previousLocation) > 50 else{ return }
        self.previousLocation = center
        self.user_lon = center.coordinate.longitude
        self.user_lat  = center.coordinate.latitude
        
        geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks,error) in
            guard let self = self else { return }
            
            if let _ = error{
                return
            }
            
            guard let placemark = placemarks?.first else {
                return
            }
            
            if let streetNumber = placemark.subThoroughfare{
                self.fullAddress = self.fullAddress + "\(streetNumber) "
            }
            
            if let streetName = placemark.thoroughfare{
                self.fullAddress = self.fullAddress + "\(streetName) "
            }
            
            if let city = placemark.locality{
                self.fullAddress = self.fullAddress + ",\(city) "
            }
            
            if let country = placemark.country{
                self.fullAddress = self.fullAddress + ",\(country)"
            }
            
            DispatchQueue.main.async {
                self.addressTF.text = self.fullAddress
            }
        }
    }
}

extension CompleteInformationVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == name{
            nameView.backgroundColor  = .selectedBorderColor
        }else{
            emailView.backgroundColor = .selectedBorderColor
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == name{
            nameView.backgroundColor = .borderColor
        }else{
            emailView.backgroundColor = .borderColor
        }
    }
}
