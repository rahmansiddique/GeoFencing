//
//  LocationManager.swift
//  GeoFencing
//
//  Created by Inam Ur Rahman on 10/11/2019.
//  Copyright © 2019 Systems Limited. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class LocationManager:NSObject {

    //MARK: - Properties
    static let shared   = LocationManager()
    private var locationManager = CLLocationManager()    
    private var observersList = [String:LocationUpdateHandler]()
    typealias LocationUpdateHandler = ((_ manager: CLLocationManager,  _ locations: [CLLocation])->Void)
    
    //MARK:- Initializer
    override init() {
        super.init()
        setupLocationManager()
        getLocationAuthentication()
        print("Location Manager Initalized")
    }
    
    //MARK: - Functions
    
    func addLocationUpdateObserver(_ observer: NSObject, completionHandler: @escaping LocationUpdateHandler) {
        observersList[observer.description] = completionHandler
    }

    func removeLocationUpdateObserver(_ observer: NSObject){
        observersList.removeValue(forKey: observer.description)
    }
    
    private func setupLocationManager(){
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func getLocationAuthentication(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            break
        case .denied:
            locationManager.requestAlwaysAuthorization()
            break
        case .authorizedAlways:
            break
        case .restricted:
            locationManager.requestAlwaysAuthorization()
            break
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            break
        default:
            break
        }
    }
}

extension LocationManager:CLLocationManagerDelegate{
    //MARK: - CLLocationManagerDelegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //MARK: - Locations are being fetched here and posted to observer
        observersList.forEach({$0.value(manager, locations)})
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    }
}
