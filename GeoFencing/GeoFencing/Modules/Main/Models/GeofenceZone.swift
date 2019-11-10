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

struct GeofenceZone {
    
    //MARK:- Properties
    var wifiInfo:WifiInfo?
    var region:CLCircularRegion?
    
    //MARK:- Initializer
    init() { }
    
    init(_ wifiInfo:WifiInfo?, _ region:CLCircularRegion?) {
        self.wifiInfo           = wifiInfo
        self.region             = region
    }
}

extension GeofenceZone:Comparable{
    static func < (lhs: GeofenceZone, rhs: GeofenceZone) -> Bool {
        //MARK: No need to override this operator
        return false
    }
    static func == (lhs: GeofenceZone, rhs: GeofenceZone) -> Bool {
        if lhs.wifiInfo == rhs.wifiInfo {return true}
        return false
    }
}
