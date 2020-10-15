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
    @ObservedObject var viewModel = MovieListViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    SearchBar(text: $searchTerm, onSearchButtonClicked: search)
                    if !self.searchTerm.isEmpty {
                        ForEach(viewModel.movies.filter {
                            !$0.release_date.isEmpty && $0.poster_path?.isEmpty == false
                        }, id: \.self) { movie in
                            NavigationLink(destination: MovieDetails(movie: movie)){
                                MovieRow(movie: movie)
                            }
                        }.listRowBackground(Color.clear)
                    }
                }
            }
            .navigationBarTitle("Search")
        }
    }
    
    private func search() {
        viewModel.fetchMovies(fetcher:  APIEndpoints.search(text: searchTerm))
    }
}
