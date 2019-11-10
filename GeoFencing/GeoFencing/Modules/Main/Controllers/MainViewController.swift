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
 
    //MARK: - Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let _ = LocationManager.shared.setDelegate(for: self as LocationManagerDelegate)
    }
    
}

extension MainViewController :LocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("received")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error ")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("status change")
    }
    
    
}
