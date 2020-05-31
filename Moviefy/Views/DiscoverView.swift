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
    @State private var selectedMediaType = "Movie"
    @State private var showRefreshView = false
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
                        ZStack {
                            RefreshableList(showRefreshView: $showRefreshView, action:{
                                self.networkManager.loadData()
                                self.showRefreshView = false
                            }){
                                if !self.networkManager.movies.results.isEmpty {
                                    SearchBar(text: self.$searchTerm)
                                    
                                    ForEach(self.networkManager.movies.results.filter{
                                        self.searchTerm.isEmpty ? true : $0.title.localizedStandardContains(self.searchTerm)
                                    }, id: \.self) { tvShow in
                                        NavigationLink(destination: MovieDetails(movie: tvShow)){
                                            MovieRow(movie: tvShow)
                                        }
                                    }
                                }
                            }
                            
                            if self.networkManager.movies.results.isEmpty {
                                Spacer()
                                Text("No movies to show")
                                Spacer()
                            }
                        }
                    } else {
                        ZStack {
                            RefreshableList(showRefreshView: $showRefreshView, action:{
                                self.networkManager.loadDataTVShows()
                                self.showRefreshView = false
                            }){
                                if !self.networkManager.tvShows.results.isEmpty {
                                    SearchBar(text: self.$searchTerm)
                                    
                                    ForEach(self.networkManager.tvShows.results.filter{
                                        self.searchTerm.isEmpty ? true : $0.title.localizedStandardContains(self.searchTerm)
                                    }, id: \.self) { tvShow in
                                        NavigationLink(destination: MovieDetails(movie: tvShow)){
                                            MovieRow(movie: tvShow)
                                        }
                                    }
                                }
                            }
                            
                            if self.networkManager.tvShows.results.isEmpty {
                                Spacer()
                                Text("No tv shows to show")
                                Spacer()
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
                    Text("Kids")
                }
            )
        }
    }
}
