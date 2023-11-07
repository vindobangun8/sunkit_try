//
//  CoreMotionVM.swift
//  Sunkitt try
//
//  Created by Datita Devindo Bahana on 05/11/23.
//

import Foundation
import CoreMotion

enum rotation{
    case landscape
    case portrait
    
}

class GyroscopeViewModel: ObservableObject {
    private let motionManager : CMMotionManager

    @Published var rotationX: Double = 0.0
    @Published var rotationY: Double = 0.0
    @Published var rotationZ: Double = 0.0
    @Published var angleRoll: Int = 0
    @Published var anglePitch: Int = 0
    @Published var angleYaw: Int = 0
    @Published var angleCombine: Int = 0
    @Published var usedAngle:Int = 0
    @Published var isSteady = false
    @Published var orientation:rotation = .portrait

    init() {
        self.motionManager = CMMotionManager()
        startUpdate()
    }

    func startUpdate(){
        if self.motionManager.isDeviceMotionAvailable {
                    motionManager.deviceMotionUpdateInterval = 0.1
                    motionManager.startDeviceMotionUpdates(to: .main) { (data, error) in
                        if let rotationrate = data {
                            let attitude = rotationrate.attitude
                            let gyro = rotationrate.gravity
                            let acceleration = rotationrate.userAcceleration
                                            // Calculate rotation degree from the attitude data
                            self.rotationX = attitude.roll
                            self.rotationY = attitude.pitch
                            self.rotationZ = attitude.yaw
                            
                            // You can set thresholds for acceleration and angular velocity based on your criteria
                            let accelerationThreshold: Double = 0.1
//                            let angularVelocityThreshold: Double = 0.1
                            
                            let isSteady = acceleration.x < accelerationThreshold &&
                                           acceleration.y < accelerationThreshold &&
                                           acceleration.z < accelerationThreshold
                            
                           

                            
                            let x2Deg = gyro.x * 180.0 / .pi
                            let y2Deg = gyro.y * 180.0 / .pi
                            let z2Deg = gyro.z * 180.0 / .pi
//                            if(roll2Deg > )
                            self.angleRoll = Int(-self.getCallibrateDegree(degree: x2Deg))
                            self.anglePitch = Int(-self.getCallibrateDegree(degree: y2Deg))
                            self.angleYaw = Int(-self.getCallibrateDegree(degree: z2Deg))
                            
                            if(abs(self.angleRoll) > 45 ){
                                self.usedAngle = self.anglePitch
                                self.orientation = .landscape
                            }
                            else if (abs(self.anglePitch) > 45){
                                self.usedAngle = self.angleRoll
                                self.orientation = .portrait
                            }
                            self.isSteady = isSteady
                                          
                        }
                    }
                }
    }
    
    func getCallibrateDegree(degree:Double) -> Double{
        
        if degree < 0.5 && degree > -0.5{
            return 0
        }
        return degree
    }
    func stopUpdates() {
        motionManager.stopDeviceMotionUpdates()
    }
}

