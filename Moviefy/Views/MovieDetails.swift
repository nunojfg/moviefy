//
//  MovieDetails.swift
//  Moviefy
//
//  Created by Nuno Gonçalves on 11/04/2020.
//  Copyright © 2019 Nuno Gonçalves. All rights reserved.
//

import SwiftUI
import RealmSwift
import SDWebImageSwiftUI

struct MovieDetails : View {
    @ObservedObject var networkManager = NetworkManager()
    @State private var isFavorite: Bool = false
    var movie: Movie
    
    var body: some View {
        VStack {
            ScrollView {
                containedView()
                HStack(alignment: .center, spacing: 60) {
                    ZStack {
                        Circle()
                            .fill(Color.clear)
                            .frame(width: 40, height: 40)
                            .overlay (
                                Circle()
                                    .trim(from: 0, to: CGFloat(movie.vote_average * 0.1))
                                    .stroke(style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
                                    .fill(movie.vote_average <= 3 ? Color.red : (movie.vote_average < 7 ? Color.orange : Color.green) )
                        )
                        Text(String(format: "%.1f", movie.vote_average)).fontWeight(.semibold)
                    }
                    Text(movie.release_date).foregroundColor(.gray).bold()
                }
                HStack {
                    Text("Description")
                        .font(.system(size: 24, weight: .bold))
                        .padding(.leading, 16)
                    Spacer()
                }
                Spacer()
                Text(movie.overview).padding(.leading, 16).lineLimit(nil)
                Spacer()
                HorizontalVideoListView(viewModel: VideoListViewModel(fetcher: APIEndpoints.videos(movie: movie)), listName: "Videos", circular: true)
                HorizontalMoviesListView(viewModel: MovieListViewModel(fetcher: APIEndpoints.recommendationsMovies(movieId: movie.id)), listName: "Recommendations")
            }
        }
        .navigationBarTitle(Text(movie.title), displayMode: .large)
        .padding()
        .onAppear {
            let realm = try! Realm()
            let results = realm.objects(FavoriteMovieRecord.self).filter("id == \(self.movie.id)")
            self.isFavorite = !results.isEmpty
        }
        .navigationBarItems(trailing:
            Button(action: {
                let realm = try! Realm()
                let results = realm.objects(FavoriteMovieRecord.self).filter("id == \(self.movie.id)")
                if let result = results.first {
                    try! realm.write {
                        realm.delete(result)
                    }
                } else {
                    try! realm.write {
                        realm.add(self.movie.toRecord(), update: .all)
                    }
                }
                
                self.isFavorite.toggle()
            }){
                favoriteButtonView()
            }
        )
    }
    
    func containedView() -> AnyView {
        
        if let posterPath = movie.poster_path {
            return AnyView(WebImage(url: URL(string:"\(BASE_IMAGE_URL)\(posterPath)")!)
                .resizable()
                .placeholder(content: {
                    Text(movie.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                })
                .frame(width: UIScreen.main.bounds.height / 8 * 3, height: UIScreen.main.bounds.height / 2)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.orange, lineWidth: 2))
                .shadow(radius: 10))
        }
        
        return AnyView(Text(movie.title)
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
            .foregroundColor(.white)
        )
    }
    
    func favoriteButtonView() -> AnyView {
        return AnyView(
            HStack {
                Image(systemName: isFavorite ? "star.fill" : "star")
            }.padding(10.0)
        )
    }
}

