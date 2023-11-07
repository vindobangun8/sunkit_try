//
//  ContentView.swift
//  Sunkitt try
//
//  Created by Datita Devindo Bahana on 09/10/23.
//

import SwiftUI
import CoreLocation
import SunKit


struct indicatorBar: Identifiable{
    public var id = UUID()
    var color: Color
    var index: Int?
    var isCurrentPos = false
}

struct ContentView: View {
    
    @StateObject var locationDataManager:LocationDataManager = LocationDataManager()
    @StateObject var Matahari = matahari()
    @State var isToggle: Bool = false
    @State var isFreeze: Bool  = false
    @State var isFront: Bool  = true
    @State private var degreeOfTilt: Double = 0
    @State var indicator : [indicatorBar] = []
    @State var text1 :String = ""
    @State var text2 :String = ""
    @State var label1 :Color = Color.white.opacity(0.4)
    @State var label2 :Color = Color.white.opacity(0.4)
    let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
    @State private var orientation = UIDeviceOrientation.unknown
    @ObservedObject var gyro = GyroscopeViewModel()
    @State private var rotationDegree: Double = 0.0
    
    init() {
        impactFeedback.prepare()
    }
    
    func indicatorColorNew(){
        let x = abs(Matahari.locationDataManager.degrees)
        var azimuth = Matahari.sunDirection!.azimuth.degrees
        if(!isFront){
            azimuth = (azimuth + 180).truncatingRemainder(dividingBy: 360)
        }
        var currentPos:Int?
        let batasKanan = (Int(azimuth) + 90) % 360
        let batasTengahBawah = (Int(azimuth) + 180) % 360
        let batasKiri = (Int(azimuth) + 270) % 360
        var whereNorth: String {
            get {
                if batasKanan + 90 > 360 { return "Q3" }
                else if batasKanan + 180 > 360 { return "Q4" }
                else if batasKanan + 270 > 360 { return "Q1" }
                else { return "Q2" }
            }
        }
        
        
        if (Int(x) > batasKanan || Int(x) < batasTengahBawah) && whereNorth == "Q3" {
            indicator[14].color = .yellow.opacity(0.2)
            indicator[14].isCurrentPos = true
            text1 = "No Sun near  "
            text2 = "Rotate left"
            label1 = .white
            label2 = .black.opacity(0.9)
            currentPos = 14
        } else if Int(x) > batasKanan && Int(x) < batasTengahBawah {
            indicator[14].color = .yellow.opacity(0.2)
            indicator[14].isCurrentPos = true
            text1 = "No Sun near  "
            text2 = "Rotate right"
            label1 = .white
            label2 = .black.opacity(0.9)
            currentPos = 14
        } else if (Int(x) > batasTengahBawah || Int(x) < batasKiri) && whereNorth == "Q4" {
            indicator[0].color = .yellow.opacity(0.2)
            indicator[0].isCurrentPos = true
            text1 = "No Sun near  "
            text2 = "Rotate left"
            label1 = .white
            label2 = .black.opacity(0.9)
            currentPos = 0
          
        } else if Int(x) > batasTengahBawah && Int(x) < batasKiri {
            indicator[0].color = .yellow.opacity(0.2)
            indicator[0].isCurrentPos = true
            text1 = "No Sun near  "
            text2 = "Rotate right"
            label1 = .white
            label2 = .black.opacity(0.9)
            currentPos = 0
        } else if (x - azimuth) < 90 || (azimuth - x) < 90 {
            if abs(x-azimuth) <= 12 {
                indicator[7].color = .green
                indicator[7].isCurrentPos = true
                text1 = "Lighting is perfect  "
                text2 = "Clear for capture"
                label1 = .green
                label2 = .white
                currentPos = 7
            } else {
                var rangeToBatasKiri: Int {
                    get {
                        if (Int(x) - batasKiri < 0) { return Int(x) - batasKiri + 360 }
                        else { return Int(x) - batasKiri }
                    }
                }
                
                let indexTemp = Int(floor(Double(rangeToBatasKiri)/12.0))
                if indexTemp >= 0 && indexTemp <= 14{
                    indicator[indexTemp].color =  .yellow
                    indicator[indexTemp].isCurrentPos = true
                    
                    if indexTemp != Matahari.previousYellowIndex {
                        impactFeedback.impactOccurred()
                        Matahari.previousYellowIndex = indexTemp
                    }
                    currentPos = indexTemp
                }
                text1 = "Need more light  "
                text2 = "Keep rotate to center  "
                label1 = .white
                label2 = .black.opacity(0.9)

                
            }
        }
        
        for i in 0...14{
            if i != currentPos{
                indicator[i].color = Color.white.opacity(0.6)
                indicator[i].isCurrentPos = false
            }
        }
        
        
    }
    
   
    
    func indicatorText() -> String {
        
        let x = abs(Matahari.locationDataManager.degrees)
        var azimuth = Matahari.sunDirection!.azimuth.degrees
        if(!isFront){
            azimuth = (azimuth + 180).truncatingRemainder(dividingBy: 360)
        }
        //        let azimuth = Double(320)
        let batasKanan = (Int(azimuth) + 90) % 360
        let batasTengahBawah = (Int(azimuth) + 180) % 360
        let batasKiri = (Int(azimuth) + 270) % 360
        var whereNorth: String {
            get {
                if batasKanan + 90 > 360 { return "Q3" }
                else if batasKanan + 180 > 360 { return "Q4" }
                else if batasKanan + 270 > 360 { return "Q1" }
                else { return "Q2" }
            }
        }
        
        if (Int(x) > batasKanan || Int(x) < batasTengahBawah) && whereNorth == "Q3" {
            return "No Sun near  "
        } else if Int(x) > batasKanan && Int(x) < batasTengahBawah {
            return "No Sun near  "
        } else if (Int(x) > batasTengahBawah || Int(x) < batasKiri) && whereNorth == "Q4" {
            return "No Sun near  "
        } else if Int(x) > batasTengahBawah && Int(x) < batasKiri {
            return "No Sun near  "
        } else if (x - azimuth) < 90 || (azimuth - x) < 90 {
            if abs(x-azimuth) <= 12 {
                return "Lighting is perfect  "
            }
        }
        return "Need more light  "
    }
    
    
    func indicatorText2() -> String {
        
        let x = abs(Matahari.locationDataManager.degrees)
        var azimuth = Matahari.sunDirection!.azimuth.degrees
        if(!isFront){
            azimuth = (azimuth + 180).truncatingRemainder(dividingBy: 360)
        }
        //        let azimuth = Double(320)
        let batasKanan = (Int(azimuth) + 90) % 360
        let batasTengahBawah = (Int(azimuth) + 180) % 360
        let batasKiri = (Int(azimuth) + 270) % 360
        var whereNorth: String {
            get {
                if batasKanan + 90 > 360 { return "Q3" }
                else if batasKanan + 180 > 360 { return "Q4" }
                else if batasKanan + 270 > 360 { return "Q1" }
                else { return "Q2" }
            }
        }
        
        if (Int(x) > batasKanan || Int(x) < batasTengahBawah) && whereNorth == "Q3" {
            return "Rotate left"
        } else if Int(x) > batasKanan && Int(x) < batasTengahBawah {
            return "Rotate right"
        } else if (Int(x) > batasTengahBawah || Int(x) < batasKiri) && whereNorth == "Q4" {
            return "Rotate left"
        } else if Int(x) > batasTengahBawah && Int(x) < batasKiri {
            return "Rotate right"
        } else if (x - azimuth) < 90 || (azimuth - x) < 90 {
            if abs(x-azimuth) <= 12 {
                return "Lighting is perfect  "
            }
        }
        return "Keep rotate to center"
    }
    
    
    func indicatorLabel() -> Color {
        
        let x = abs(Matahari.locationDataManager.degrees)
        var azimuth = Matahari.sunDirection!.azimuth.degrees
        if(!isFront){
            azimuth = (azimuth + 180).truncatingRemainder(dividingBy: 360)
        }
        let arahMatahari = hitungArahMatahari(utara: x, sunlight: azimuth)
        
        if arahMatahari >= -12 && arahMatahari <= 12 { // tengah
            return .green
        }
        
        return .white
    }
    
    func indicatorLabel2() -> Color {
        
        let x = abs(Matahari.locationDataManager.degrees)
        var azimuth = Matahari.sunDirection!.azimuth.degrees
        
        if(!isFront){
            azimuth = (azimuth + 180).truncatingRemainder(dividingBy: 360)
        }
        let arahMatahari = hitungArahMatahari(utara: x, sunlight: azimuth)
        
        if arahMatahari >= -12 && arahMatahari <= 12{ // tengah
            return .white
        }
        
        return .black.opacity(0.9)
    }
    
    func hitungArahMatahari(utara:Double,sunlight:Double) -> Double{
        return  abs(utara) - sunlight
        
    }
    
    func isLevelShown() -> Bool{
        if (gyro.usedAngle > 0 && gyro.usedAngle < 20 || gyro.usedAngle < 0 && gyro.usedAngle > -20){
            return true
        }
        return false
    }
    
    
    
    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    HStack (spacing: 8) {
                        ForEach(indicator) { item in
                            Rectangle()
                                .frame(height: isFreeze ? 16 : 44)
                                .cornerRadius(isFreeze ? 24 : 6)
                            // MARK:    indicator COlor next task ubah jadi state smua baru jalanin fungsi di onappear atau yang lain
                                .foregroundColor(isFreeze ? Color.white.opacity(0.2) : item.color)
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
                    
//                    Image("freezer")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(height: isFreeze ? 40 : 68)
//                        .offset(x: isFreeze ? 40 : 120)
//                        .opacity(isFreeze ? 0.8 : 0)
                }
                .padding(16)
                
                HStack(spacing: 0) {
                    Text(isFreeze ? "Tap to turn on" : text1)
                    Text(isFreeze ? "" : text2).fontWeight(.semibold)
                }
                .font(.system(size: 14))
                .foregroundStyle(isFreeze ? Color.black.opacity(0.9) : label2)
                .fontDesign(.rounded)
                .padding(.vertical, 6)
                .padding(.horizontal, 16)
                .background(isFreeze ? Color.white : label1)
                .cornerRadius(100)
                .opacity(isFreeze ? 0.4 : 1)
                Spacer()
                if(isLevelShown() && gyro.isSteady){
                    if(gyro.orientation == .portrait){
                        VStack{
                            Divider()
                                           .background(Color.white) // Set the color of the line
                                           .frame(width:150) // Set the height of the line
                                           .rotationEffect(.degrees(Double(gyro.usedAngle)))
                        }
                    }
                    else if (gyro.orientation == .landscape){
                        HStack{
                            Divider()
                                           .background(Color.white) // Set the color of the line
                                           .frame(height:150) // Set the height of the line
                                           .rotationEffect(.degrees(Double(gyro.usedAngle)))
                        }
                    }
                    
                    
                }
                    
                Spacer()
                Text(gyro.isSteady ? "steady" :"not steady")
                Text("Gyroscope Data:")
                Text("Rotation X: \(gyro.rotationX)")
                Text("Rotation Y: \(gyro.rotationY)")
                Text("Rotation Z: \(gyro.rotationZ)")
//                Text("initial: \(gyro.initialAttitude!)")
                Text("angleX: \(gyro.angleRoll)")
                Text("angleY: \(gyro.anglePitch)")
                Text("angleZ: \(gyro.angleYaw)")
                Text("currAngle: \(gyro.usedAngle)")
//                Text("angleComb: \(gyro.angleCombine)")
                Text("north position : \(Matahari.locationDataManager.degrees )")
                Text("Arah Matahari : \(hitungArahMatahari(utara: Matahari.locationDataManager.degrees, sunlight: Matahari.sunDirection!.azimuth.degrees))")
                Text("azimuth : \((Matahari.sunDirection!.azimuth.degrees + 180).truncatingRemainder(dividingBy: 360) )")
                    .bold()
                Group {
                           if orientation.isPortrait {
                               Text("Portrait")
                           } else if orientation.isLandscape {
                               Text("Landscape")
                           } else if orientation.isFlat {
                               Text("Flat")
                           } else {
                               Text("Unknown")
                           }
                       }
                       .onRotate { newOrientation in
                           orientation = newOrientation
                       }
            }
            .onTapGesture {
                withAnimation(Animation.easeInOut(duration: 0.1)) {
                    isFreeze.toggle()
                }
            }
        }
        .onChange(of: Matahari.locationDataManager.degrees){
            if( indicator.count > 0){
                indicatorColorNew()
            }
            
        }
        .onAppear(){
            for i in 0...14{
                let indiTemp = indicatorBar(color:Color.white.opacity(0.6),index: i)
                
                indicator.append(indiTemp)
            }
        }
        .onDisappear(){
            gyro.stopUpdates()
        }
        .background(Color.black.opacity(0.8))
        
        
    }
    
    
}

#Preview {
    ContentView()
}
