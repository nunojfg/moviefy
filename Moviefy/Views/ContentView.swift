//
//  ContentView.swift
//  Moviefy
//
//  Created by Nuno Gonçalves on 11/04/2020.
//  Copyright © 2019 Nuno Gonçalves. All rights reserved.
//

import SwiftUI

struct ContentView : View {
    
    init() {
        UITableView.appearance().separatorStyle = .none
    }
    
    var body: some View {
        
        TabView {
            DiscoverView()
                .tabItem {
                    Image(systemName: "play.fill")
                    Text("Discover")
                }
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass.circle.fill")
                    Text("Search")
                }
            FavoritesView()
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Favorites")
                }
            SettingsView()
                .tabItem {
                    Image(systemName: "line.horizontal.3.decrease.circle.fill")
                    Text("Settings")
                }
        }
        
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
#endif
