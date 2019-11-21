//
//  GeofenceZone.swift
//  GeoFencing
//
//  Created by Inam Ur Rahman on 10/11/2019.
//  Copyright © 2019 Systems Limited. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

struct GeofenceZone{
    
    //MARK:- Properties
    var wifiSSID:String?
    var region:CLCircularRegion?
    
    //MARK:- Initializer
    init() { }
    
    init(_ region:CLCircularRegion?, _ wifiSSID:String?) {
        self.region             = region
        self.wifiSSID           = wifiSSID
    }
    
    
}
