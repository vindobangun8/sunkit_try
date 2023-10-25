//
//  SunKit.swift
//  Sunkitt try
//
//  Created by Datita Devindo Bahana on 09/10/23.
//

import Foundation
import SunKit
import CoreLocation
class matahari : NSObject, ObservableObject {
    @Published var location : CLLocation?
    @Published var timezone : TimeZone?
    @Published var sunDirection : Sun?
    @Published var previousYellowIndex : Int?
    var locationDataManager : LocationDataManager
    
    override init(){
    
        self.locationDataManager = LocationDataManager()
//        print(locationDataManager.lastLocation?.coordinate.latitude as Any,"<<<lati")
        self.location = .init(latitude: locationDataManager.locationManager.location?.coordinate.latitude ?? 0, longitude: locationDataManager.locationManager.location?.coordinate.longitude ?? 0)
        self.timezone = .init(identifier: "Western Indonesia Time") ?? .current
        super.init()
        let myDate: Date = Date() // Your current date
        self.sunDirection = .init(location:location!, timeZone: timezone!)
        self.sunDirection?.setDate(myDate)
     
//        print(timezone as Any ,"<<timezone")
        
//        print(sunDirection?.azimuth.degrees ?? 0)
       
    }
    
  
}
