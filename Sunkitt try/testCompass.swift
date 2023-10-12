//
//  testCompass.swift
//  Sunkitt try
//
//  Created by Datita Devindo Bahana on 11/10/23.
//

import SwiftUI

struct testCompass: View {
//    @StateObject var locationDataManager:LocationDataManager = LocationDataManager()
    @StateObject var Matahari = matahari()
    
    var body: some View {
        Text("north position : \(Matahari.locationDataManager.degrees )")
        Image("arrow")
            .rotationEffect(Angle(degrees: Matahari.locationDataManager.degrees))
    }
}

#Preview {
    testCompass()
}
