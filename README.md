# GeoFencing
Check if the device is in a specified GeoFence.

[![Swift version](https://img.shields.io/badge/swift-5.0-orange.svg?style=flat.svg)](https://img.shields.io/badge/swift-5.0-orange.svg?style=flat.svg)

- [Requirements](#requirements)
- [Installation](#installation)
- [Flow](#flow)










## Requirements

- iOS 11.0+
- Xcode 10.2+
- Swift 5.0+






## Installation

Download it and run in Xcode!







## Flow

- Provide permission for the location access 
- Default values will be populated as SSID: "PTCL-BB" Radius: 1000.0
- Both SSID and Radius are editable
- App observes the changes in realtime 
- You can change the radius and SSID as per your specifications 
- If the device is connected to the specified SSID, it will be deemed as inside the geofence regardless of the radius
- If the device is not connected to the specified SSID and it goes out of the specified radius it will be deemed outside of the geofence











## Orientation
 
 - Portrait










## Author

**Inam Ur Rahman** - (https://github.com/rahmansiddique)