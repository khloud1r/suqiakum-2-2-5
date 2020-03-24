//
//  DeliveryLocationVC.swift
//  suqiakum
//
//  Created by HadyHammad on 3/12/20.
//  Copyright © 2020 Hany Karam. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
class DeliveryLocationVC: BaseViewController {
    
    // MARK :- Instance
    static func instance () -> DeliveryLocationVC {
        let storyboard = UIStoryboard.init(name: "Account", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "DeliveryLocationVC") as! DeliveryLocationVC
    }
    
    // MARK :- Outlets
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet var mapView: UIView!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var titleTxtField: UITextField!
    @IBOutlet weak var locationTxtView: UITextView!
    @IBOutlet weak var addNewLocationBtn: UIButton!
    @IBOutlet var deleteAlertView: UIView!
    @IBOutlet weak var yesBtn: UIButton!
    @IBOutlet weak var noBtn: UIButton!
    
    // MARK :- Instance Variables
    var addressArray:[Address] = []
    var locationManager  = CLLocationManager()
    let regionInMeters : Double = 500
    var choosenLatitude  : Double = 0
    var choosenLongitude : Double = 0
    var previousLocation  : CLLocation?
    var fullAddress = ""
    var deleteID:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        setupComponent()
    }
    
    func setupComponent() {
        deleteAlertView.addCornerRadius(8)
        deleteAlertView.addBorderWith(width: 0.2, color: .blue)
        deleteAlertView.addNormalShadow()
        yesBtn.addBtnCornerRadius(15)
        noBtn.addBtnCornerRadius(15)
        yesBtn.addBtnBorderWith(width: 0.5, color: UIColor(red: 255/255, green: 191/255, blue: 42/255, alpha: 1))
        noBtn.addBtnBorderWith(width: 0.5, color: UIColor(red: 255/255, green: 191/255, blue: 42/255, alpha: 1))
        addNewLocationBtn.addBtnCornerRadius(5)
        titleTxtField.addCornerRadius(10)
        locationTxtView.addCornerRadius(5)
        if let lat = self.locationManager.location?.coordinate.latitude, let lon = self.locationManager.location?.coordinate.longitude {
            self.choosenLatitude  = lat
            self.choosenLongitude = lon
        }
        loadLocations()
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate{
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            map.setRegion(region, animated: true)
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
        map.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
        previousLocation = getCenterLocation(for: map)
    }
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let lat = mapView.centerCoordinate.latitude
        let lon = mapView.centerCoordinate.longitude
        return CLLocation(latitude: lat, longitude: lon)
    }
    
    func loadLocations() {
        self.showLoadingIndicator()
        NetworkApi.sendRequest( method: .get, url: getAddress, header: authentication, completion: { (err,status,response: AddressResponse?) in
            self.hideLoadingIndicator()
            if err == nil{
                if status!{
                    if let addresses = response?.data{
                        self.addressArray = addresses
                        self.tableview.reloadData()
                    }
                }
            }
        })
    }
    
    @IBAction func buAddLocation(_ sender: Any) {
        Show_Map_View()
    }
    
    @IBAction func buCloseMap(_ sender: Any) {
        Hide_Map_View()
    }
    
    @IBAction func addNewLocation(_ sender: Any) {
        print(self.choosenLatitude)
        print(self.choosenLongitude)
        let param = ["name": titleTxtField.text ?? "", "description": locationTxtView.text ?? "", "lat": self.choosenLatitude, "lng": self.choosenLongitude] as [String : Any]
        self.showLoadingIndicator()
        NetworkApi.sendRequest(method: .post, url: address, parameters: param, header: authentication, completion: { (err, status, response: AddressAddedResponse?) in
            self.hideLoadingIndicator()
            if err == nil{
                if status!{
                    if let msg = response?.message{
                        self.showAlertsuccess(title: msg)
                        self.Hide_Map_View()
                        self.loadLocations()
                    }
                }
            }
        })
    }
    
    func Hide_Map_View() {
        self.shadowView.isHidden = true
        UIView.animate(withDuration: 0.3) {
            self.mapView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.mapView.alpha = 0
            self.mapView.removeFromSuperview()
        }
    }
    
    func Show_Map_View() {
        self.shadowView.isHidden = false
        self.view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: self.topView.bottomAnchor, constant: 16).isActive = true
        mapView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        mapView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.8).isActive = true
        mapView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.93).isActive = true
        mapView.transform = CGAffineTransform.init(scaleX:  1.3, y: 1.3)
        mapView.alpha = 0
        UIView.animate(withDuration: 0.7) {
            self.mapView.alpha = 1
            self.mapView.transform = CGAffineTransform.identity
        }
    }
    
    func Hide_Delete_View() {
        UIView.animate(withDuration: 0.3) {
            self.deleteAlertView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.deleteAlertView.alpha = 0
            self.deleteAlertView.removeFromSuperview()
        }
    }
    
    func Show_Delete_View() {
        self.view.addSubview(deleteAlertView)
        deleteAlertView.translatesAutoresizingMaskIntoConstraints = false
        deleteAlertView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        deleteAlertView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        deleteAlertView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        deleteAlertView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.97).isActive = true
        deleteAlertView.transform = CGAffineTransform.init(scaleX:  1.3, y: 1.3)
        deleteAlertView.alpha = 0
        UIView.animate(withDuration: 0.7) {
            self.deleteAlertView.alpha = 1
            self.deleteAlertView.transform = CGAffineTransform.identity
        }
    }
    
    @IBAction func buDeleteCancel(_ sender: Any) {
        Hide_Delete_View()
    }
    
    @IBAction func buDeleteConfirm(_ sender: Any) {
        guard let id = self.deleteID else{return}
        let param = ["address_id": id]
        self.showLoadingIndicator()
        NetworkApi.sendRequest(method: .delete, url: address, parameters: param, header: authentication, completion: { (err, status, response: DeleteResponse?) in
            self.hideLoadingIndicator()
            if err == nil{
                if status!{
                    if let msg = response?.message{
                        self.Hide_Delete_View()
                        self.loadLocations()
                        self.showAlertsuccess(title: msg)
                    }
                }
            }
        })
    }
    
    @IBAction func buBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension DeliveryLocationVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressTVC", for: indexPath) as! AddressTVC
        cell.configure(address: self.addressArray[indexPath.row])
        cell.deleteBtn.tag = self.addressArray[indexPath.row].id!
        cell.deleteBtn.addTarget(self, action: #selector(buRemoveItemPress(_:)), for: .touchUpInside)
        cell.editBtn.tag = self.addressArray[indexPath.row].id!
        cell.editBtn.addTarget(self, action: #selector(buEditItemPress(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func buRemoveItemPress(_ sender:UIButton){
        if self.addressArray.count <= 1{
            self.showAlertWiring(title: "لا يمكنك الحذف يجب ان تحتوي علي عنوان واحد علي الاقل")
            return
        }
        self.deleteID = sender.tag
        Show_Delete_View()
    }
    
    @objc func buEditItemPress(_ sender:UIButton) {
        print(self.addressArray[sender.tag].name ?? "")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height * 0.16
    }
}

extension DeliveryLocationVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

extension DeliveryLocationVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        self.fullAddress = ""
        let center = getCenterLocation(for: mapView)
        let geoCoder = CLGeocoder()
        
        guard let previousLocation = self.previousLocation else { return }
        guard center.distance(from: previousLocation) > 50 else{ return }
        self.previousLocation = center
        self.choosenLongitude = center.coordinate.longitude
        self.choosenLatitude  = center.coordinate.latitude
        
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
                self.locationTxtView.text = self.fullAddress
            }
        }
    }
}
