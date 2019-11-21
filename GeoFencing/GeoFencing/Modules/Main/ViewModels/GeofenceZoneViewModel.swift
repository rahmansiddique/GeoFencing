//
//  GeofenceZoneViewModel.swift
//  GeoFencing
//
//  Created by Inam Ur Rahman on 20/11/2019.
//  Copyright © 2019 Systems Limited. All rights reserved.
//

import Foundation
import CoreLocation

class GeofenceZoneViewModel:NSObject{
    
    //MARK: - Properties
    private let reachability = try! Reachability()
    private var observableModel:ObservableModel<GeofenceZone>
    private var deviceCurrentLocation:CLLocation?
    private var isFirstTimeLocationAddedToGeoFence = false
    private var userInputSSIDName:String = "" {
        didSet{
            processResult()
        }
    }
    private var resultString : String = "" {
        didSet{
            resultStringUpdate(resultString)
        }
    }
    
    //MARK: - Callbacks
    var resultStringUpdate : ((String)->Void) = {_ in }
    
    
    //MARK: - Initializer
    init(_ geoFenceZone : GeofenceZone = GeofenceZone()) {
        self.observableModel = ObservableModel(geoFenceZone)
        super.init()
        let _ = LocationManager.shared.setDelegate(for: self as LocationManagerDelegate)
        setupReachability()
        setupModelChangeObserver()
    }
    
    //MARK: - Selectors
    @objc private func reachabilityChanged(note: Notification) {
        // Update the fence with the new WiFi settings
        self.observableModel.value.wifiSSID = WifiManager.shared.getConnectedWifiSSID().first
    }
    
    //MARK: - Functions
    
    private func setupModelChangeObserver(){
        observableModel.addAndNotify(observer: self, completionHandler: { [weak self] (model) in
            guard let weakSelf = self else{return}
            weakSelf.processResult()
        })
    }
    
    private func setupReachability(){
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("Could not start reachability notifier")
        }
    }

    private func isDeviceInsideGeoFence()->Bool{
        var isInsideGeoFence = false
        
        if let currentWifiSSID = self.observableModel.value.wifiSSID{
            if currentWifiSSID == userInputSSIDName{
                isInsideGeoFence = true
            }
        }
        
        if let currentLocation = self.deviceCurrentLocation, let currentRegion = self.observableModel.value.region{
            if currentRegion.contains(currentLocation.coordinate){
                isInsideGeoFence = true
            }
        }
        return isInsideGeoFence
    }
    
    private func processResult(){
        if isDeviceInsideGeoFence(){
            resultString = "Status: Inside Geofence"
        }else{
            resultString = "Status: Outside Geofence"
        }
    }
    
    func updateRegion(with newRadius:Double){
        guard let oldRegion = self.observableModel.value.region else {return}
        self.observableModel.value.region = CLCircularRegion(center: oldRegion.center, radius: newRadius, identifier: oldRegion.identifier)
    }
    
    func updateSSID(with newSSID:String){
        self.userInputSSIDName = newSSID
    }
}

extension GeofenceZoneViewModel:LocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else{return}
        deviceCurrentLocation = latestLocation
        if !isFirstTimeLocationAddedToGeoFence{
            isFirstTimeLocationAddedToGeoFence = true
            let radius = 100.0
            self.observableModel.value.region = CLCircularRegion(center: latestLocation.coordinate, radius: radius, identifier: "defaultRegion")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    }
}
