//
//  DiscoverView.swift
//  Moviefy
//
//  Created by Nuno Gonçalves on 22/03/2020.
//  Copyright © 2020 Nuno Gonçalves. All rights reserved.
//

import SwiftUI

struct DiscoverView: View {
    @State private var searchTerm: String = ""
    @ObservedObject var networkManager = NetworkManager()
    @State private var selectedMediaType = "Movie"
    var mediaTypes = ["Movie", "TV"]
    
    init() {
        networkManager.loadData()
        networkManager.loadDataTVShows()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Picker(selection: $selectedMediaType, label: EmptyView()) {
                    ForEach(mediaTypes, id: \.self) { value in
                        Text(value)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                
                if networkManager.loading {
                    
                    Spacer()
                    Wrap(UIActivityIndicatorView()) {
                        if self.networkManager.loading {
                            $0.startAnimating()
                        } else {
                            $0.stopAnimating()
                        }
                    }
                } else {
                    
                    if selectedMediaType == "Movie" {
                        if networkManager.movies.results.isEmpty {
                            Spacer()
                            Text("No movies to show")
                            Spacer()
                        } else {
                            List {
                                SearchBar(text: $searchTerm)
                                
                                ForEach(networkManager.movies.results.filter{
                                    self.searchTerm.isEmpty ? true : $0.title.localizedStandardContains(self.searchTerm)
                                }, id: \.self) { movie in
                                    NavigationLink(destination: MovieDetails(movie: movie)){
                                        MovieRow(movie: movie)
                                    }
                                }
                            }
                        }
                    } else {
                        if networkManager.tvShows.results.isEmpty {
                            Spacer()
                            Text("No tv shows to show")
                            Spacer()
                        } else {
                            List {
                                SearchBar(text: $searchTerm)
                                
                                ForEach(networkManager.tvShows.results.filter{
                                    self.searchTerm.isEmpty ? true : $0.title.localizedStandardContains(self.searchTerm)
                                }, id: \.self) { tvShow in
                                    NavigationLink(destination: MovieDetails(movie: tvShow)){
                                        MovieRow(movie: tvShow)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Discover")
            .navigationBarItems(trailing:
                Button(action: {
                    self.networkManager.loadData()
                }){
                    Image(systemName: "arrow.clockwise.circle.fill")
                }
            )
        }
    }
}
