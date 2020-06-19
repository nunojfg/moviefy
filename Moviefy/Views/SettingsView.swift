//
//  SettingsView.swift
//  Moviefy
//
//  Created by Nuno Gonçalves on 22/03/2020.
//  Copyright © 2020 Nuno Gonçalves. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    NavigationLink(destination: AboutView()){
                        Text("About")
                    }
                    NavigationLink(destination: ThemesView()) {
                        Text("Themes")
                    }
                    NavigationLink(destination: MobileDataUsageView()) {
                        Text("Mobile Data Usage")
                    }
                }
                Spacer()
                Text("Version: \(UIApplication.shared.versionBuild)")
                Spacer()
            }
            .navigationBarTitle("Settings")
        }
    }
}
