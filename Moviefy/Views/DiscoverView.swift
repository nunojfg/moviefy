//
//  DiscoverView.swift
//  Moviefy
//
//  Created by Nuno Gonçalves on 22/03/2020.
//  Copyright © 2020 Nuno Gonçalves. All rights reserved.
//

import SwiftUI
import SwiftUIPullToRefresh

struct DiscoverView: View {
    @State private var searchTerm: String = ""
    @ObservedObject var networkManager = NetworkManager()
    @ObservedObject var genresMovieListViewModel = GenresMovieListViewModel(endpoint: APIEndpoints.movieGenres)
    @ObservedObject var genresTVShowsListViewModel = GenresMovieListViewModel(endpoint: APIEndpoints.tvShowGenres)
    @State private var selectedMediaType = "Movie"
    @State private var showRefreshView = false
    var mediaTypes = ["Movie", "TV"]
    
    init() {
        //networkManager.fetchMovies(fetcher: APIEndpoints.topRatedMovies)
        //networkManager.loadData()
        //networkManager.loadDataTVShows()
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading) {
                        Picker(selection: $selectedMediaType, label: EmptyView()) {
                            ForEach(mediaTypes, id: \.self) { value in
                                Text(value)
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                        
                        if selectedMediaType == "Movie" {
                            HorizontalMoviesListView(viewModel: MovieListViewModel(fetcher: APIEndpoints.topRatedMovies), listName: "Top Rated", circular: true)
                            HorizontalMoviesListView(viewModel: MovieListViewModel(fetcher: APIEndpoints.popularMovies), listName: "Popular")
                            ForEach(genresMovieListViewModel.genres, id: \.id) { genre in
                                HorizontalMoviesListView(viewModel:
                                    MovieListViewModel(fetcher: APIEndpoints.moviesForGenre(genreId: genre.id)),
                                                         listName: genre.name)
                            }
                        } else {
                            HorizontalMoviesListView(viewModel: MovieListViewModel(fetcher: APIEndpoints.topRatedTVShows), listName: "Top Rated", circular: true)
                            HorizontalMoviesListView(viewModel: MovieListViewModel(fetcher: APIEndpoints.popularTVShows), listName: "Popular")
                            ForEach(genresTVShowsListViewModel.genres, id: \.id) { genre in
                                HorizontalMoviesListView(viewModel:
                                    MovieListViewModel(fetcher: APIEndpoints.moviesForGenre(genreId: genre.id)),
                                                         listName: genre.name)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Discover")
        }
    }
}
