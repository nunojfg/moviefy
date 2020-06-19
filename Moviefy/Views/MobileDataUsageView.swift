//
//  MobileDataUsageView.swift
//  Moviefy
//
//  Created by Nuno Gonçalves on 6/19/20.
//  Copyright © 2020 Liem Vo. All rights reserved.
//

import SwiftUI

struct MobileDataUsageView: View {
    @State private var isAutomatic = true
    
    var body: some View {
        VStack {
            Toggle(isOn: $isAutomatic) {
                Text("Automatic")
            }.padding(.all)
            Spacer()
        }.navigationBarTitle("Mobile Data Usage", displayMode: .large)
    }
}
