//
//  Extensions.swift
//  GeoFencing
//
//  Created by Inam Ur Rahman on 10/11/2019.
//  Copyright © 2019 Systems Limited. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

extension CLLocationCoordinate2D{
    func isEqual(to otherCordinate:CLLocationCoordinate2D)->Bool
    {return self.latitude == otherCordinate.latitude && self.longitude == otherCordinate.longitude}
    
    func isIn(region:CLCircularRegion)->Bool{
        if region.contains(self){return true}
        return false
    }
}
