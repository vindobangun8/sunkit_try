//
//  ContentView.swift
//  Sunkitt try
//
//  Created by Datita Devindo Bahana on 09/10/23.
//

import SwiftUI
import CoreLocation
import SunKit

struct ContentView: View {
    @StateObject var locationDataManager:LocationDataManager = LocationDataManager()
    @StateObject var Matahari = matahari()
   
    
//    var userLatitude: String {
//        return "\(sun.locationDataManager.lastLocation?.coordinate.latitude ?? 0)"
//    }
//    
//    var userLongitude: String {
//        return "\(sun.locationDataManager.lastLocation?.coordinate.longitude ?? 0)"
//    }
    
   
    
    var body: some View {
        ZStack {
            VStack {
                Text("latitude: \(Matahari.locationDataManager.locationManager.location?.coordinate.latitude ?? 0)")
                Text("longitude: \(Matahari.locationDataManager.locationManager.location?.coordinate.longitude ?? 0)")
                Text("Azimuth sun: \(Matahari.sunDirection?.azimuth.degrees ?? 0)")
                Text("Altitude sun: \(Matahari.sunDirection?.altitude.degrees ?? 0)")
                Text("Sunrise Time : \(formatter(waktu:Matahari.sunDirection!.sunrise))")
                Text("Sunset Time : \(formatter(waktu:Matahari.sunDirection!.sunset))")
                Text("north position : \(Matahari.locationDataManager.degrees )")
                Text("Arah Matahari : \(hitungArahMatahari(utara: Matahari.locationDataManager.degrees, sunlight: Matahari.sunDirection!.azimuth.degrees))")
                    .bold()
                ZStack{
                    Group{
//                        Image("arrow")
//                        .center)
                        ZStack{
                            Circle()
                                .frame(width: 400,height: 400)
                                .foregroundColor(.white)
                                .overlay(
                                Circle()
                                    .frame(width: 50,height: 50)
                                    .foregroundColor(.red))
                            VStack{
                                Circle()
                                    .frame(width: 40,height: 40)
                                    .foregroundColor(.blue)
                                
                                    Spacer()
                                
                                    
                            }
                            .frame(width: 400,height: 400)
                            
                            
                        }
                       
                    }
                }.frame(width: 20,height: 20)
                    .rotationEffect(Angle(degrees: hitungArahMatahari(utara: Matahari.locationDataManager.degrees, sunlight: Matahari.sunDirection!.azimuth.degrees)),anchor: .center)
               
                    
                  
            }
        }
        
        
    }
    
    func hitungArahMatahari(utara:Double,sunlight:Double) -> Double{
        return  utara + sunlight
    }
    func formatter(waktu:Date) -> String {
//        print(waktu)
        let formater = DateFormatter()
        formater.dateFormat = "HH:mm E"
        
        
        return formater.string(from:waktu)
    }
       
}

#Preview {
    ContentView()
}
