//
//  ViewController.swift
//  GeoFencing
//
//  Created by Inam Ur Rahman on 10/11/2019.
//  Copyright © 2019 Systems Limited. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: BaseVC {
    
    //MARK: Properties
    var geoFenceZone:GeofenceZone = GeofenceZone()
    var deviceCurrentLocation:CLLocation?
    var isFirstTimeLocationAddedToGeoFence = false
    let reachability = try! Reachability()
    
    //MARK: - IBOutlets
    @IBOutlet weak var radiusTextField: UITextField!
    @IBOutlet weak var ssidTextField: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    
    //MARK: - Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let _ = LocationManager.shared.setDelegate(for: self as LocationManagerDelegate)
        setupInitialGeoFence()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupReachability()
    }

    //MARK: - Functions
    
    func setupInitialGeoFence(){
        self.geoFenceZone.wifiInfo = WifiManager.shared.getConnectedWifiInfo().first
        // Hardcoding my current cordinates until the new cordinates arrive
        self.geoFenceZone.region = CLCircularRegion(center: CLLocationCoordinate2DMake(31.56506294147416, 74.28639842354846), radius: 1000, identifier: "defaultRegion")
        
       setupUI()
    }
    func setupUI(){
        
        radiusTextField.delegate = self
        ssidTextField.delegate = self
        // Setting basic settings by default
        // You can change the SSID name to the currently connected network to observe the changes
        ssidTextField.text = "PTCL-BB"
        radiusTextField.text = "1000.0"

        //Adding tap gesture to dismiss keyboard on tap, without adding any library
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        updateUI()
    }
    
    func setupReachability(){
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    func isDeviceInsideGeoFence()->Bool{
        var isInsideGeoFence = false
        
        if let currentWifi = self.geoFenceZone.wifiInfo{
            if currentWifi.wifiSSID == self.ssidTextField.text ?? ""{
                isInsideGeoFence = true
            }
        }
        
        if let currentLocation = self.deviceCurrentLocation, let currentRegion = self.geoFenceZone.region{
            if currentRegion.contains(currentLocation.coordinate){
                isInsideGeoFence = true
            }
        }
        
        return isInsideGeoFence
    }
    
    func updateUI(){
        if isDeviceInsideGeoFence(){
            DispatchQueue.main.async {
                self.statusLabel.text =  "Status: Inside Geofence"
            }
        }else{
            DispatchQueue.main.async {
                self.statusLabel.text =  "Status: Outside Geofence"
            }
        }
    }
    
    
    //MARK: - Selectors
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            print("Reachable via WiFi")
        case .cellular:
            print("Reachable via Cellular")
        case .unavailable:
            print("Network not reachable")
        case .none:
            print("Network not reachable")
        }
        // Update the fence with the new WiFi settings
        self.geoFenceZone.wifiInfo = WifiManager.shared.getConnectedWifiInfo().first
        updateUI()
    }
}

extension MainViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField == radiusTextField{
            let newRadius  = Double(textField.text ?? "") ?? 0.0
            guard let oldRegion = self.geoFenceZone.region else {updateUI();return}
            self.geoFenceZone.region = CLCircularRegion(center: oldRegion.center, radius: newRadius, identifier: oldRegion.identifier)
        }
        updateUI()
    }
}

extension MainViewController :LocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else{return}
        deviceCurrentLocation = latestLocation
        if !isFirstTimeLocationAddedToGeoFence{
            // First time when the location is fetched i setted it upas the center of circular region
            isFirstTimeLocationAddedToGeoFence = true
            let radius = 1000.0
            self.geoFenceZone.region = CLCircularRegion(center: latestLocation.coordinate, radius: radius, identifier: "defaultRegion")
        }
        updateUI()
        print(latestLocation)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    }
    
}
