//
//  UITabWrapper.swift
//  Moviefy
//
//  Created by Nuno Gonçalves on 05/04/2020.
//  Copyright © 2020 Nuno Gonçalves. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

struct UITabView: View {
    var viewControllers: [UIHostingController<AnyView>]
    @State var selectedIndex: Int = 0
    
    init(_ views: [Tab]) {
        self.viewControllers = views.map {
            let host = UIHostingController(rootView: $0.view)
            host.tabBarItem = $0.barItem
            return host
        }
    }
    
    var body: some View {
        TabBarController(controllers: viewControllers, selectedIndex: $selectedIndex)
            .edgesIgnoringSafeArea(.all)
    }
    
    struct Tab {
        var view: AnyView
        var barItem: UITabBarItem
        
        init<V: View>(view: V, barItem: UITabBarItem) {
            self.view = AnyView(view)
            self.barItem = barItem
        }
        
        // convenience
        init<V: View>(view: V, title: String?, image: String, selectedImage: String? = nil) {
            let selectedImage = selectedImage != nil ? UIImage(systemName: selectedImage!) : nil
            let barItem = UITabBarItem(title: title, image: UIImage(systemName: image), selectedImage: selectedImage)
            self.init(view: view, barItem: barItem)
        }
    }
}
