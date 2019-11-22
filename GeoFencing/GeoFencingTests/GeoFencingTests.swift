//
//  GeoFencingTests.swift
//  GeoFencingTests
//
//  Created by Inam Ur Rahman on 22/11/2019.
//  Copyright © 2019 Systems Limited. All rights reserved.
//

import XCTest
import CoreLocation
@testable import GeoFencing

class GeoFencingTests: XCTestCase {

    var geoFenceZoneViewModel:GeofenceZoneViewModel = GeofenceZoneViewModel()
    var geoFence = GeofenceZone()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        geoFenceZoneViewModel = GeofenceZoneViewModel()
        geoFence = GeofenceZone()
    }

    override func tearDown() {
    }

    func testGeoFenceZoneModelInjectSSID() {
        
        geoFence.wifiSSID = "TEST SSID"
        XCTAssertEqual(geoFence.wifiSSID, "TEST SSID", "WifiSSID be 'TEST SSID'")
    }
    
    func testGeoFenceZoneModelInjectRegion() {
        let center = CLLocationCoordinate2D(latitude: 35.0, longitude: 73.0)
        let region = CLCircularRegion(center: center, radius: 100.0, identifier: "testRegion")
        geoFence.region = region
        XCTAssertEqual(geoFence.region, region, "Both the regions should be same")
    }

    func testCallbackOnRadiusStringInGeoFenceViewModel(){
        let radius = 600.0
        geoFenceZoneViewModel.radiusUpdatedCallback = { (radiusString) in
            XCTAssertEqual(radiusString, "600.00 meters", "Radius string should be 'radius' meters")
            XCTAssertNotEqual(radiusString, "600.000 meters", "Radius string should only display 2 decimal places")
        }
        geoFenceZoneViewModel.updateRegion(with: radius)
    }
    
    func testGeoFenceViewModelInitializationWithGeoFence(){
        geoFence.wifiSSID = "SomeSSID"
        geoFenceZoneViewModel = GeofenceZoneViewModel(geoFence)
        XCTAssertEqual(geoFenceZoneViewModel.getZonesCurrentSSID(), "SomeSSID", "WifiSSID must be 'SomeSSID'")
    }
}
