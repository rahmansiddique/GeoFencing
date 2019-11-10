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

//MARK: - Custom LocationManagerDelegates

protocol LocationManagerDelegate:class {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
}


class LocationManager:NSObject {

    //MARK: - Properties
    static let shared   = LocationManager()
    private var locationManager = CLLocationManager()
    private var delegates:[LocationManagerDelegate?] = [LocationManagerDelegate?]()
    
    //MARK:- Initializer
    override init() {
        super.init()
        setupLocationManager()
        getLocationAuthentication()
        print("Location Manager Initalized")
    }
    
    //MARK: - Functions
    
    func setDelegate(for controllerReference:LocationManagerDelegate?){
        delegates.append(controllerReference)
    }
    
    func removeDelegate(for controllerReference:LocationManagerDelegate?){
        delegates.removeAll { (delegate) -> Bool in
            return delegate == nil
        }
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
        //MARK: - Locations are being fetched here
        print("Location updated")
        for delgate in delegates{
            delgate?.locationManager(manager, didUpdateLocations: locations)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //MARK: - Failed to update the location
        print("Failed to fetch locations \(error.localizedDescription)" )
        for delgate in delegates{
            delgate?.locationManager(manager, didFailWithError: error)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Authorization status changed")
        for delgate in delegates{
            delgate?.locationManager(manager, didChangeAuthorization: status)
        }
    }
}
