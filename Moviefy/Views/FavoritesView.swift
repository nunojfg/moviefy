//
//  FavoritesView.swift
//  Moviefy
//
//  Created by Nuno Gonçalves on 04/04/2020.
//  Copyright © 2020 Nuno Gonçalves. All rights reserved.
//

import SwiftUI
import Combine

struct FavoritesView: View {
    @State private var searchTerm: String = ""
    @State private var showShareSheet = false
    @EnvironmentObject var favorites: FavoriteMovieResults
    
    var body: some View {
        NavigationView {
            VStack {
                if favorites.results.isEmpty {
                    Text("No favorites to show")
                } else {
                    List {
                        SearchBar(text: $searchTerm)
                        ForEach(favorites.results.filter {
                            self.searchTerm.isEmpty ? true : $0.title.localizedStandardContains(self.searchTerm)
                        }, id: \.self) { movie in
                            NavigationLink(destination: MovieDetails(movie: movie)){
                                MovieRow(movie: movie)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Favorites")
            .sheet(isPresented: $showShareSheet) {
                ShareSheet(activityItems: self.movieList())
            }
            .navigationBarItems(trailing:
                Button(action: {
                    self.showShareSheet = true
                }) {
                    Image(systemName: "square.and.arrow.up.fill")
                }.opacity(favorites.results.isEmpty ? 0 : 1)
            )
        }
    }
    
    func movieList() -> [String] {
        
        var list: [String] = []
        list.append("My Moviefy favorite list:\n\n")
        
        var index = 0
        
        list.append(contentsOf: self.favorites.results.compactMap { movie -> String? in
            index += 1
            return "\(index).\(movie.title)\n"
        })
        
        return list
    }
}
