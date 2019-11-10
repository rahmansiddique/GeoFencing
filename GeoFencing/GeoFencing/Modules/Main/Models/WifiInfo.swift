//
//  WifiInfo.swift
//  GeoFencing
//
//  Created by Inam Ur Rahman on 10/11/2019.
//  Copyright © 2019 Systems Limited. All rights reserved.
//

import Foundation

struct WifiInfo{
    //MARK:- Properties
    var wifiSSID:String

    init(_ wifiSSID:String) {
        self.wifiSSID           = wifiSSID
       
    }
}

extension WifiInfo:Comparable{
    static func < (lhs: WifiInfo, rhs: WifiInfo) -> Bool {
        //MARK: No need to override this operator
        return false
    }
    static func == (lhs: WifiInfo, rhs: WifiInfo) -> Bool {
        return lhs.wifiSSID == rhs.wifiSSID
    }
}
