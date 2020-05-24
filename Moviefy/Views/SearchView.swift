//
//  SearchView.swift
//  Moviefy
//
//  Created by Nuno Gonçalves on 22/03/2020.
//  Copyright © 2020 Nuno Gonçalves. All rights reserved.
//

import SwiftUI

struct SearchView: View {
    @State private var searchTerm: String = ""
    @ObservedObject var networkManager = NetworkManager()
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    SearchBar(text: $searchTerm, onSearchButtonClicked: search)
                    if !self.searchTerm.isEmpty {
                        ForEach(networkManager.moviesSearch.results.filter {
                            !$0.release_date.isEmpty
                        }, id: \.self) { movie in
                            NavigationLink(destination: MovieDetails(movie: movie)){
                                MovieRow(movie: movie)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Search")
        }
    }
    
    private func search() {
        networkManager.loadSearchData(searchString: searchTerm)
    }
}
