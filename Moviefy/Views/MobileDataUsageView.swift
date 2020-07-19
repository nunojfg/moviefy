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
    @State private var listIndex = 0
    var list = ["Just Wi-Fi", "Economize data"]
    
    var body: some View {
        VStack {
            Toggle(isOn: $isAutomatic) {
                Text("Automatic")
            }.padding(.all)
            Picker(selection: $listIndex, label:
                Text("")) {
                    ForEach(0..<list.count) {
                        Text(self.list[$0]).tag($0)
                    }
            }
            
            
            Spacer()
        }.navigationBarTitle("Mobile Data Usage", displayMode: .large)
    }
}
