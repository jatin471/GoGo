//
//  LocationHandler.swift
//  GoGo
//
//  Created by JATIN YADAV on 05/08/23.
//

import CoreLocation

class LocationHandler : NSObject , CLLocationManagerDelegate {
    
    static let shared = LocationHandler()
    var locationManager : CLLocationManager!
    var location : CLLocation?
    
    override init() {
        super.init()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
}
