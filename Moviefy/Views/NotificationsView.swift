//
//  NotificationsView.swift
//  Moviefy
//
//  Created by Nuno Gonçalves on 7/23/20.
//  Copyright © 2020 Liem Vo. All rights reserved.
//

import SwiftUI

struct NotificationsView: View {
    @State private var isAutomatic = false
    var body: some View {
        VStack {
            Toggle(isOn: $isAutomatic) {
                Text("Push notifications")
            }.padding(.all)
            Spacer()
        }
        .navigationBarTitle("Notifications", displayMode: .large)
    }
}
