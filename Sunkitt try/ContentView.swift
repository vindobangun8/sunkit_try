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
    @State var isToggle: Bool = false
    @State var isFreeze: Bool  = false
    @State private var degreeOfTilt: Double = 0
    
    let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
    
    init() {
        impactFeedback.prepare()
    }
    
    
    
    func indicatorColor(i:Int) -> Color{
        let x = abs(Matahari.locationDataManager.degrees)
        let azimuth = Matahari.sunDirection!.azimuth.degrees
        let arahMatahari = hitungArahMatahari(utara: x, sunlight: azimuth)
        
        
        if arahMatahari >= -5 && arahMatahari <= 5{ // tengah
            if i == 7 {
                return .green
            }
        }
        else if  arahMatahari <= -90 && arahMatahari >= -180{ // kiri
            if i == 14 {
                return .yellow.opacity(0.2)
            }
        }
        else if  arahMatahari >= 90 { // kanan
            if i == 0 {
                return .yellow.opacity(0.2)
            }
        }
//        else if  arahMatahari >= 90 || arahMatahari <= 180 { // kanan
//            if i == 0 {
//                return .yellow.opacity(0.2)
//            }
//        }
       
        else{
                if i == abs(Int((180 - (arahMatahari + 90)) / 12)) {
                                    if i != Matahari.previousYellowIndex {
                                        impactFeedback.impactOccurred()
                                        Matahari.previousYellowIndex = i
                                    }
                                    return .yellow
                                }
        }
//        else {
//            // rumusan
//            // x 360 - 180
//            // if x == 360, f(x) == 0
//            // if x == 348, f(x) == 1
//            // if x == 180, f(x_ == 11
//            if i == Int((360 - x) / 12) {
//                    if i != Matahari.previousYellowIndex {
//                        impactFeedback.impactOccurred()
//                        Matahari.previousYellowIndex = i
//                    }
//                    return .yellow
//                }
//        }
        return Color.white.opacity(0.6)
    }
    
    
    func indicatorText() -> String {
        
        let x = abs(Matahari.locationDataManager.degrees)
        let azimuth = Matahari.sunDirection!.azimuth.degrees
        let arahMatahari = hitungArahMatahari(utara: x, sunlight: azimuth)
        
        if arahMatahari >= -5 && arahMatahari <= 5{ // tengah
            return "Lighting is perfect  "
        }
        else if  arahMatahari >= 100 || arahMatahari <= -180 { // kanan
            return "No Sun near  "
        }
        else if  arahMatahari <= -100 && arahMatahari >= -180{ // kiri
            return "No Sun near  "
        }
        
        
        return "Need more light  "
    }
//    
//    
//    func indicatorText() -> String {
//        
//        let x = abs(Matahari.locationDataManager.degrees)
//        let azimuth = Matahari.sunDirection!.azimuth.degrees
//        
//        if x > 0 && x < 90 { // kiri
//                return "No Sun near  "
//        }
//        
//        else if x >= 90 && x < 180 { //kanan
//                return "No Sun near  "
//        }
//        
//        else if x >= azimuth && x < azimuth + 20 { // tengah
//                return "Lighting is perfect  "
//        }
//        
//        return "Need more light  "
//    }
    
    func indicatorText2() -> String {
        
        let x = abs(Matahari.locationDataManager.degrees)
        let azimuth = Matahari.sunDirection!.azimuth.degrees
        let arahMatahari = hitungArahMatahari(utara: x, sunlight: azimuth)
        
        
        if arahMatahari >= -5 && arahMatahari <= 5{ // tengah
            return "Clear for capture"
        }
        else if  arahMatahari >= 100 || arahMatahari <= -180 { // kanan
            return "Rotate left"
        }
        else if  arahMatahari <= -100 && arahMatahari >= -180{ // kiri
            return "Rotate right"
        }
        return "Keep rotate to center"
    }
    
    
    func indicatorLabel() -> Color {
        
        let x = abs(Matahari.locationDataManager.degrees)
        let azimuth = Matahari.sunDirection!.azimuth.degrees
        let arahMatahari = hitungArahMatahari(utara: x, sunlight: azimuth)
        
        if arahMatahari >= -5 && arahMatahari <= 5 { // tengah
            return .green
        }
        
        return .white
    }
    
    func indicatorLabel2() -> Color {
        
        let x = abs(Matahari.locationDataManager.degrees)
        let azimuth = Matahari.sunDirection!.azimuth.degrees
        let arahMatahari = hitungArahMatahari(utara: x, sunlight: azimuth)
        
        if arahMatahari >= -5 && arahMatahari <= 5{ // tengah
            return .white
        }
        
        return .black.opacity(0.9)
    }

 func hitungArahMatahari(utara:Double,sunlight:Double) -> Double{
        return  abs(utara) - sunlight
    }
    func formatter(waktu:Date) -> String {
//        print(waktu)
        let formater = DateFormatter()
        formater.dateFormat = "HH:mm E"
        
        
        return formater.string(from:waktu)
    }
    
    
    var body: some View {
        
        ZStack {
            
            VStack {
                ZStack {
                    HStack (spacing: 8) {
                        ForEach(0...14, id: \.self) { index in
                            Rectangle()
                                .frame(height: isFreeze ? 16 : 44)
                                .cornerRadius(isFreeze ? 24 : 6)
                                .foregroundColor(isFreeze ? Color.white.opacity(0.2) : indicatorColor(i: index))
                        }
                    }
                    .padding(12)
                    .background(Color.white.opacity(isFreeze ? 0.6 : 0.2))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .inset(by: 2)
                            .stroke(Color.white.opacity(isFreeze ? 0 : 0.2), lineWidth: 4)
                    )
                    
                    Image("freezer")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: isFreeze ? 40 : 68)
                        .offset(x: isFreeze ? 40 : 120)
                        .opacity(isFreeze ? 0.8 : 0)
                }
                .padding(16)
    
                HStack(spacing: 0) {
                    Text(isFreeze ? "Tap to turn on" : indicatorText())
                    Text(isFreeze ? "" : indicatorText2()).fontWeight(.semibold)
                }
                .font(.system(size: 14))
                .foregroundStyle(isFreeze ? Color.black.opacity(0.9) : indicatorLabel2())
                .fontDesign(.rounded)
                .padding(.vertical, 6)
                .padding(.horizontal, 16)
                .background(isFreeze ? Color.white : indicatorLabel())
                .cornerRadius(100)
                .opacity(isFreeze ? 0.4 : 1)
                
                Spacer()
                
                Text("north position : \(Matahari.locationDataManager.degrees )")
                Text("Arah Matahari : \(hitungArahMatahari(utara: Matahari.locationDataManager.degrees, sunlight: Matahari.sunDirection!.azimuth.degrees))")
                                   .bold()

                Text("azimuth : \(Matahari.sunDirection!.azimuth.degrees)")
                                   .bold()
                
                
            }
            .onTapGesture {
                withAnimation(Animation.easeInOut(duration: 0.1)) {
                    isFreeze.toggle()
                }
            }
        }
        .background(Color.black.opacity(0.8))
        
        
    }

    
}

#Preview {
    ContentView()
}
