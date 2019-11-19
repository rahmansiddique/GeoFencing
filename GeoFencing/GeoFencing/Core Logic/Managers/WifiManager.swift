//
//  WifiUtilities.swift
//  GeoFencing
//
//  Created by Inam Ur Rahman on 10/11/2019.
//  Copyright © 2019 Systems Limited. All rights reserved.
//

import Foundation
import SystemConfiguration.CaptiveNetwork

class WifiManager{
    
    //MARK:- Properties
    static let shared = WifiManager()
    
    //MARK:- Initializer
    init() { }
    
    
    func getConnectedWifiSSID() -> Array<String> {
        guard let interfaceNames = CNCopySupportedInterfaces() as? [String] else {
            return []
        }
        let wifiInfo:[String] = interfaceNames.compactMap{ name in
            guard let info = CNCopyCurrentNetworkInfo(name as CFString) as? [String:AnyObject] else {
                return nil
            }
            guard let ssid = info[kCNNetworkInfoKeySSID as String] as? String else {
                return nil
            }
            guard let _ = info[kCNNetworkInfoKeyBSSID as String] as? String else {
                return nil
            }
            return ssid
        }
        return wifiInfo
    }
}
